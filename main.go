package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"time"

	"github.com/AlecAivazis/survey/v2"
	"gopkg.in/yaml.v2"
)

var (
	Info   = Teal
	Warn   = Yellow
	Fata   = Red
	Header = Magenta
)

var (
	Black   = Color("\033[1;30m%s\033[0m")
	Red     = Color("\033[1;31m%s\033[0m")
	Green   = Color("\033[1;32m%s\033[0m")
	Yellow  = Color("\033[1;33m%s\033[0m")
	Purple  = Color("\033[1;34m%s\033[0m")
	Magenta = Color("\033[1;35m%s\033[0m")
	Teal    = Color("\033[1;36m%s\033[0m")
	White   = Color("\033[1;37m%s\033[0m")
)

var (
	AwsEKS   = "AWS/EKS"
	AzureAKS = "Azure/AKS"
	GcpGKE   = "GCP/GKE"
)

func ExecutionPath(cloudprovider string) string {
	switch cloudprovider {
	case "aws":
		return AwsEKS
	case "gcp":
		return GcpGKE
	case "azure":
		return AzureAKS
	default:
		return ""
	}
}

func Color(colorString string) func(...interface{}) string {
	sprint := func(args ...interface{}) string {
		return fmt.Sprintf(colorString,
			fmt.Sprint(args...))
	}
	return sprint
}

type Awstfinputs struct {
	Region                     string `json:"region"`
	Environment                string `json:"environment"`
	Application                string `json:"application"`
	Vpccidr                    string `json:"vpc_cidr"`
	Eksalbaddonregistryaccount string `json:"eksalb_addon_registryaccount"`
	Enabledns                  bool   `json:"enable_dns"`
	Hostedzonename             string `json:"hostedzonename"`
	Enablessl                  bool   `json:"enable_ssl"`
}

type Awsekshelminputs struct {
	Environment  string `yaml:"environment"`
	Loadbalancer string `yaml:"loadbalancer"`
	Externaltype bool   `yaml:"externalType"`
	Hostname     string `yaml:"hostname"`
	Hostnamesdk  string `yaml:"hostnamesdk"`
	Enablessl    bool   `yaml:""`
}

// the questions to ask for AWS
var awsQs = []*survey.Question{
	{
		Name: "region",
		Prompt: &survey.Input{
			Message: "Enter your preffered region:",
			Help:    "An example- For AWS: eu-central-1 , For GCP: europe-west1 etc ",
			Default: "eu-central-1",
		},
		Validate: survey.Required,
	},
	{
		Name: "application",
		Prompt: &survey.Input{
			Message: "Enter your application name:",
			Default: "memphis",
		},
	},
	{
		Name: "vpccidr",
		Prompt: &survey.Input{
			Message: "Enter VPC CIDR for EKS Cluster:",
			Default: "10.0.0.0/16",
		},
	},
	{
		Name: "eksalbaddonregistryaccount",
		Prompt: &survey.Input{
			Message: "AWS Provided Account number for EKS Cluster Addons:",
			Help:    "EKS Registry details can be found here. https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html",
			Default: "602401143452",
		},
	},
	{
		Name: "hostedzonename",
		Prompt: &survey.Input{
			Message: "Please provide hosted zone name(Enter to skip)",
			Help:    "Route53 Hosted Zone name to attach load balancer.",
		},
	},
	{
		Name: "enablessl",
		Prompt: &survey.Confirm{
			Message: "Do you to HTTPS/SSL Encryption(Enter to skip if hosted zone not provided)?",
			Default: false,
		},
	},
}

var awsEKSHemlQs = []*survey.Question{
	{
		Name: "loadbalancer",
		Prompt: &survey.Select{
			Message: "Select UI AWS Load Balancer Type:",
			Options: []string{"nlb", "alb"},
			Default: "nlb",
		},
	},
	{
		Name: "externaltype",
		Prompt: &survey.Confirm{
			Message: "Do you want to expose Memphis UI to external(public)?",
		},
	},
	// {
	// 	Name: "hostname",
	// 	Prompt: &survey.Input{
	// 		Message: "Please provide hostname prefix(Enter to skip if hosted zone NOT provided)",
	// 		Help:    "It will be added DNS Prefix for privided Hosted Zone Name.",
	// 		Default: "memphis",
	// 	},
	// },
}

func main() {
	var (
		cloudprovider string
		environment   string
	)
	fmt.Println(Header("Welcome to Memphis Terraform CLI..."))
	args := os.Args[1:]
	if len(args) == 1 && args[0] == "help" {
		fmt.Println(Warn("Supported Args: <help|init|apply|destroy>"))
		fmt.Println(Warn("No Args will start into interactive mode."))
		return
	}
	// } else {
	// 	if len(args) != 1 {
	// 		fmt.Println(Fata("Please enter correct inputs. Type help for more details abt inputs."))
	// 		return
	// 	}
	// }

	cp_prompt := &survey.Select{
		Message: "Choose your preferred cloud provider:",
		Options: []string{"aws", "gcp", "azure"},
		Default: "aws",
	}
	err := survey.AskOne(cp_prompt, &cloudprovider)
	if err != nil {
		fmt.Println(Fata(err.Error()))
		//return err
	}

	env_prompt := &survey.Input{
		Message: fmt.Sprintf("Enter your environment for Cloud Provider - %s", cloudprovider),
		Default: "dev",
	}
	err = survey.AskOne(env_prompt, &environment)
	if err != nil {
		fmt.Println(Fata(err.Error()))
		//return err
	}

	fmt.Println(Info("Thanks..Progressing with Public Cloud Provider - ", cloudprovider))
	tfinputfilename := fmt.Sprintf("%s-%s.tfvars.json", "aws", environment)
	helminputfilename := fmt.Sprintf("values.%s%s.yaml", "aws", environment)
	var action string
	if len(args) == 1 {
		action = args[0]
	}
	switch action {
	case "init":
		if err := memphisInit(cloudprovider, environment, tfinputfilename, helminputfilename); err != nil {
			fmt.Println(Fata(err))
			return
		}
	case "apply":
		if err := memphisApply(cloudprovider, environment); err != nil {
			fmt.Println(Fata(err))
			return
		}
	case "destroy":
		if err := memphisDestroy(cloudprovider, environment, tfinputfilename); err != nil {
			fmt.Println(Fata(err))
			return
		}
	default:
		//fmt.Println(Fata("Unsupported argument passed. Type help for more details abt inputs."))
		if err := memphisInit(cloudprovider, environment, tfinputfilename, helminputfilename); err != nil {
			fmt.Println(Fata(err))
			return
		}
		var proceed bool
		proceedConf := &survey.Confirm{
			Message: "Do you want to proceed with above plan for deployment ?",
		}
		err := survey.AskOne(proceedConf, &proceed)
		if err != nil {
			return
		}
		if proceed {
			if err := memphisApply(cloudprovider, environment); err != nil {
				fmt.Println(Fata(err))
				return
			}
		}

	}
}

func memphisInit(cloudprovider string, environment string, tfinputfilename string, helminputfilename string) error {
	//var inputfilename string
	var tfWorkDir = ExecutionPath(cloudprovider)
	var isAutoLoad bool
	// Checking if input files already exist.
	_, err := os.Stat(tfinputfilename)
	if !errors.Is(err, os.ErrNotExist) {
		_, err = os.Stat(helminputfilename)
		if !errors.Is(err, os.ErrNotExist) {
			autoload := &survey.Confirm{
				Message: "Input files already exist. Do you want to proceed with them ?",
			}
			err := survey.AskOne(autoload, &isAutoLoad)
			if err != nil {
				return err
			}
		}
	}
	if !isAutoLoad {
		switch cloudprovider {
		case "aws":
			err := handleaws(environment, tfinputfilename, helminputfilename)
			if err != nil {
				return err
			}
			fmt.Println(Info("Thanks for inputs."))
		case "gcp":
			fmt.Println("This is not supported.")
		case "azure":
			fmt.Println("This is not supported.")
		}
	}

	fmt.Println(Info("Running Terraform..."))
	tfExecPath, err := exec.LookPath("terraform")
	if err != nil {
		//fmt.Println(Fata(err.Error()))
		return err
	}
	cmdtfinit := &exec.Cmd{
		Path:   tfExecPath,
		Args:   []string{tfExecPath, "init", "-input=false"},
		Dir:    tfWorkDir,
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}

	fmt.Println(cmdtfinit.String())
	//Running Terraform init
	if err := cmdtfinit.Run(); err != nil {
		//fmt.Println(Fata("Terraform Init Error:", err))
		err := fmt.Errorf("terraform init error:%s", err.Error())
		return err
	}
	tfplanoutput := fmt.Sprintf("-out=%s%s.tfplan", cloudprovider, environment)
	cmdtfplan := &exec.Cmd{
		Path:   tfExecPath,
		Args:   []string{tfExecPath, "plan", fmt.Sprintf("-var-file=../../%s", tfinputfilename), tfplanoutput, "-input=false"},
		Dir:    tfWorkDir,
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}

	fmt.Println(cmdtfplan.String())
	//Running Terraform Plan
	if err := cmdtfplan.Run(); err != nil {
		//fmt.Println(Fata("Terraform Plan Error:", err))
		err := fmt.Errorf("terraform plan error:%s", err.Error())
		return err
	}

	return nil

}

func memphisApply(cloudprovider string, environment string) error {
	tfWorkDir := ExecutionPath(cloudprovider)
	tfExecPath, err := exec.LookPath("terraform")
	if err != nil {
		return err
	}
	tfplan := fmt.Sprintf("%s%s.tfplan", cloudprovider, environment)
	cmdtfapply := &exec.Cmd{
		Path:   tfExecPath,
		Args:   []string{tfExecPath, "apply", "-auto-approve", "-input=false", tfplan},
		Dir:    tfWorkDir,
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}

	fmt.Println(cmdtfapply.String())
	//Running Terraform Plan
	fmt.Println(Info("Applying generated terraform plan..."))

	if err := cmdtfapply.Run(); err != nil {
		//fmt.Println(Fata("Terraform Apply Error:", err))
		err := fmt.Errorf("terraform apply error:%s", err.Error())
		return err
	}

	fmt.Println(Info("Sleeping for 2 minutes to make sure infrastructure is ready"))
	time.Sleep(120 * time.Second)
	fmt.Println(Info("Deploying Memphis Application..."))
	shellExecPath, err := exec.LookPath("sh")
	if err != nil {
		return err
	}
	memphisdep := &exec.Cmd{
		Path:   shellExecPath,
		Args:   []string{shellExecPath, "memphis-install.sh", environment},
		Dir:    tfWorkDir,
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}

	if err := memphisdep.Run(); err != nil {
		err := fmt.Errorf("memphis Deployment error:%s", err.Error())
		return err
	}

	return nil
}

func memphisDestroy(cloudprovider string, environment string, tfinputfilename string) error {
	tfWorkDir := ExecutionPath(cloudprovider)
	fmt.Println(Info("Destroying Memphis Application..."))
	shellExecPath, err := exec.LookPath("sh")
	if err != nil {
		return err
	}
	memphisdep := &exec.Cmd{
		Path:   shellExecPath,
		Args:   []string{shellExecPath, "memphis-uninstall.sh", environment},
		Dir:    tfWorkDir,
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}

	if err := memphisdep.Run(); err != nil {
		err := fmt.Errorf("memphis destroy error:%s", err.Error())
		return err
	}
	fmt.Println(Info("Sleeping for 2 minutes to make sure ELB is removed."))
	time.Sleep(120 * time.Second)
	tfExecPath, err := exec.LookPath("terraform")
	if err != nil {
		return err
	}
	cmdtfdestroy := &exec.Cmd{
		Path:   tfExecPath,
		Args:   []string{tfExecPath, "destroy", fmt.Sprintf("-var-file=../../%s", tfinputfilename), "-auto-approve", "-input=false"},
		Dir:    tfWorkDir,
		Stdout: os.Stdout,
		Stderr: os.Stdout,
	}

	fmt.Println(cmdtfdestroy.String())
	//Running Terraform Plan
	fmt.Println(Info("Destroying memphis infrastructure..."))

	if err := cmdtfdestroy.Run(); err != nil {
		//fmt.Println(Fata("Terraform Apply Error:", err))
		err := fmt.Errorf("terraform destroy error:%s", err.Error())
		return err
	}

	return nil
}

func handleaws(env string, tfinputfilename string, helminputfilename string) error {
	awstfinputs := Awstfinputs{}
	awsekshelminputs := Awsekshelminputs{}
	awsekshelminputs.Environment = env
	awstfinputs.Environment = env

	err := survey.Ask(awsQs, &awstfinputs)
	if err != nil {
		//fmt.Println(err.Error())
		return err
	}
	err = survey.Ask(awsEKSHemlQs, &awsekshelminputs)
	if err != nil {
		//fmt.Println(err.Error())
		return err
	}
	//fmt.Println(awstfinputs)
	//Setting up Enable DNS based on hostname input.
	if awstfinputs.Hostedzonename == "" {
		awstfinputs.Enabledns = false
	} else {
		awstfinputs.Enabledns = true
	}
	//Setting up Hostname for Helm input.
	if awstfinputs.Enabledns {
		awsekshelminputs.Hostname = fmt.Sprintf("%s.memphis.%s", env, awstfinputs.Hostedzonename)
		awsekshelminputs.Hostnamesdk = fmt.Sprintf("%ssdk.memphis.%s", env, awstfinputs.Hostedzonename)
		if awstfinputs.Enablessl {
			awsekshelminputs.Enablessl = true
		}
	} else {
		awsekshelminputs.Hostname = ""
		awsekshelminputs.Hostnamesdk = ""
		awsekshelminputs.Enablessl = false
	}

	//Writing inputs into Json and Yaml files.
	tfinputjson, _ := json.MarshalIndent(awstfinputs, "", " ")
	err = os.WriteFile(tfinputfilename, tfinputjson, 0644)
	if err != nil {
		//fmt.Println(err.Error())
		return err
	}

	helminputjson, err := yaml.Marshal(&awsekshelminputs)

	if err != nil {
		return err
	}
	err = os.WriteFile(helminputfilename, helminputjson, 0644)
	if err != nil {
		//fmt.Println(err.Error())
		return err
	}
	return nil
}
