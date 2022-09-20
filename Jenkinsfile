node {
    withCredentials ([
      string(credentialsId: 'CLIENT_ID', variable: 'ARM_CLIENT_ID'),
      string(credentialsId: 'CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
      string(credentialsId: 'TENANT_ID', variable: 'ARM_TENANT_ID'),
      string(credentialsId: 'HUB_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
      string(credentialsId: 'SPOKE_SUBSCRIPTION_ID', variable: 'TF_VAR_SUBSCRIPTION_ID')
    ])
    {
      withEnv(["git_url=https://github.com/bhadra-123/terraform_storage_backend"]) {

        ansiColor('xterm') {
          stage('checkout') {
              checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${git_url}"]]])
          }
          stage('azlogin') {
            script {
              sh '''
                  az account clear
                  az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
                  az account show
                '''  
            }
          }
          if ( Azure_Environment.equals("dev") ) {
            init "${ARM_SUBSCRIPTION_ID}"
          }
          else {
            init "${TF_VAR_SUBSCRIPTION_ID}"
          }

        //   stage('Init') {
        //     script {
        //       checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${git_url}"]]])
        //       if ( Azure_Environment.equals("dev") ) {
        //         sh '''
        //           az account clear
        //           az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
        //           az account set -s $ARM_SUBSCRIPTION_ID
        //           az account show
        //           terraform init
        //         '''   
        //       }
        //       else {
        //         sh '''
        //           az account clear
        //           az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
        //           az account set -s $TF_VAR_SUBSCRIPTION_ID
        //           az account show
        //           terraform init
        //         '''                 
        //       }
        //     }
        //   }

        //   stage ('Plan') {
        //     script {
        //       if ( Azure_Environment.equals("dev") && Terraform_Command.equals("Terraform Plan") ) {
        //         sh '''
        //           az account set -s $ARM_SUBSCRIPTION_ID
        //           az account show
        //           terraform plan -var Environment=$Azure_Environment
        //         '''   
        //       }
        //       else if ( Azure_Environment.equals("prod") && Terraform_Command.equals("Terraform Plan") ) {
        //         sh '''
        //           az account set -s $TF_VAR_SUBSCRIPTION_ID
        //           az account show
        //           terraform plan -var Environment=$Azure_Environment
        //         '''                
        //       }
        //     }
        //   }

        //   stage ('Apply') {
        //     script {
        //       if ( Azure_Environment.equals("dev") && Terraform_Command.equals("Terraform Apply") ) {
        //         sh '''
        //           az account set -s $ARM_SUBSCRIPTION_ID
        //           az account show
        //           terraform apply --auto-approve -var Environment=$Azure_Environment
        //         '''   
        //       }
        //       else if ( Azure_Environment.equals("prod") && Terraform_Command.equals("Terraform Apply") ) {
        //         sh '''
        //           az account set -s $TF_VAR_SUBSCRIPTION_ID
        //           az account show
        //           terraform apply --auto-approve -var Environment=$Azure_Environment
        //         '''                
        //       }
        //     }
        //   }

        //   stage ('Destroy') {
        //     script {
        //       if ( Azure_Environment.equals("dev") && Terraform_Command.equals("Terraform Destroy") && Destroy.equalsIgnoreCase("destroy") ) {
        //         sh '''
        //           az account set -s $ARM_SUBSCRIPTION_ID
        //           az account show
        //           terraform destroy --auto-approve -var Environment=$Azure_Environment
        //         '''   
        //       }
        //       else if ( Azure_Environment.equals("prod") && Terraform_Command.equals("Terraform Destroy") ) {
        //         sh '''
        //           az account set -s $TF_VAR_SUBSCRIPTION_ID
        //           az account show
        //           terraform destroy --auto-approve -var Environment=$Azure_Environment
        //         '''                
        //       }
        //     }
        //   }        
        }
      } 
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////
// Testing Pipeline -1  //
//////////////////////////

// @Library('jenkins-shared-library') _

// def environmentVariables = [:]

// pipeline {

//   agent any

//   options {
//     buildDiscarder(logRotator(numToKeepStr:'10'))
//     timeout(time: 5, unit: 'MINUTES')
//     ansiColor('xterm')
//   }

//   parameters{
//     choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy')
//     choice(name: 'Environment', choices: 'dev\nprod')
//     string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
//   }

//   stages {

//     stage ("Getting Environment Variables") {
//       steps {
//         script {

//           environmentVariables.hubCreds   = GetJenkinsSecretIds(environmentVariables.environment, "hub")
//           environmentVariables.spokeCreds = GetJenkinsSecretIds(environmentVariables.environment, "spoke")

//           if (Environment.equals("dev")) {
//             environmentVariables.SUBSCRIPTION_ID = environmentVariables.hubCreds.SUBSCRIPTION_ID
//             environmentVariables.CLIENT_ID = environmentVariables.hubCreds.CLIENT_ID
//             environmentVariables.CLIENT_SECRET = environmentVariables.hubCreds.CLIENT_SECRET
//           }
//           else if (Environment.equals("prod")) {
//             environmentVariables.SUBSCRIPTION_ID = environmentVariables.spokeCreds.SUBSCRIPTION_ID 
//             environmentVariables.CLIENT_ID = environmentVariables.spokeCreds.CLIENT_ID 
//             environmentVariables.CLIENT_SECRET = environmentVariables.spokeCreds.CLIENT_SECRET              
//           }
//         }
//       }
//     }

//     stage("Setting Environment Variables") {
//       environment {
//         ARM_TENANT_ID       = credentials("TENANT_ID")        
//         ARM_SUBSCRIPTION_ID = credentials("${environmentVariables.SUBSCRIPTION_ID}")
//         ARM_CLIENT_ID       = credentials("${environmentVariables.CLIENT_ID}")
//         ARM_CLIENT_SECRET   = credentials("${environmentVariables.CLIENT_SECRET}")         
//       }
//       stages {

//         stage ('Init') {
//           steps {
//             script {
//               sh '''
//                 az account clear
//                 az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
//                 az account set -s $ARM_SUBSCRIPTION_ID
//                 az account show
//                 printenv
//                 terraform init
//               '''          
//             }
//           }
//         }

//         stage ('Plan') {
//           when {
//             expression { Terraform_Command.equals("Terraform Plan") }
//           }      
//           steps {
//             script {
//               sh '''
//                 terraform plan
//               '''          
//             }
//           }
//         }

//       }    
//     }
//   }
// }
