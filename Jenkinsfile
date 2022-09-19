pipeline {

  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr:'10'))
    timeout(time: 5, unit: 'MINUTES')
    ansiColor('xterm')
  }

  parameters{
    choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy')
    choice(name: 'Environment', choices: 'dev\nprod')
    string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
  }

  environment {
    ARM_SUBSCRIPTION_ID = credentials("HUB_SUBSCRIPTION_ID")
    //TF_VAR_tenant_id    = credentials("SPOKE_SUBSCRIPTION_ID")
    ARM_TENANT_ID       = credentials("TENANT_ID")
    ARM_CLIENT_ID       = credentials("CLIENT_ID")
    ARM_CLIENT_SECRET   = credentials("CLIENT_SECRET")
  }

  stages {

    stage ('Init') {
      steps {
        script {
          sh '''
            az account clear
            az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
            az account set -s $ARM_SUBSCRIPTION_ID
            az account show
            printenv
            terraform init
          '''          
        }
      }
    }

    // stage ('Init') {
    //     steps {
    //       sc
    //         sh '''
    //             az account clear
    //             az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
    //             az account set -s $ARM_SUBSCRIPTION_ID
    //             az account show
    //             printenv
    //             terraform init
    //         '''            
    //     }
    // }

    stage ('Plan') {
        when {
            expression { Terraform_Command.equals("Terraform Plan") }
        }
        steps {
            sh 'terraform plan'
        }
    }

    // stage ('Apply') {
    //     when {
    //         expression { Terraform_Command.equals("Terraform Apply") }
    //     }
    //     steps {
    //         sh 'terraform apply --auto-approve'
    //     }
    // }

    // stage ('Destroy') {
    //     when {
    //         expression { Terraform_Command.equals("Terraform Destroy") && Destroy.equalsIgnoreCase("destroy") }
    //     }
    //     steps {
    //         sh 'terraform destroy --auto-approve'
    //     }
    // }

   }
}



