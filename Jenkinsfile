pipeline {

  agent any

  options {
    ansiColor('xterm')
  }

  parameters{
    choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy', description: 'Select Terraform Operation')
    string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
  }

  environment {
    ARM_TENANT_ID       = credentials("TENANT_ID")
    ARM_SUBSCRIPTION_ID = credentials("SUBSCRIPTION_ID")
    ARM_CLIENT_ID       = credentials("CLIENT_ID")
    ARM_CLIENT_SECRET   = credentials("CLIENT_SECRET")
  }

  stages {

    stage ('Init') {
        steps {
            sh (script: "rm -r ./.terraform", returnStatus: true)
            sh (script: 'az account clear', returnStatus: true)
            sh 'az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID'
            sh 'az account set -s $ARM_SUBSCRIPTION_ID'
            sh 'az account show'
            sh 'terraform init'
            sh 'printenv'
        }
    }

    stage ('Plan') {
        when {
            expression { Terraform_Command.equals("Terraform Plan") }
        }
        steps {
            sh 'terraform plan'
        }
    }

    stage ('Apply') {
        when {
            expression { Terraform_Command.equals("Terraform Apply") }
        }
        steps {
            sh 'terraform apply --auto-approve'
        }
    }

    stage ('Destroy') {
        when {
            expression { Terraform_Command.equals("Terraform Destroy") && Destroy.equalsIgnoreCase("destroy") }
        }
        steps {
            sh 'terraform destroy --auto-approve'
        }
    }

   }
}



