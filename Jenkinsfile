// pipeline {

//   agent any

//   options {
//     buildDiscarder(logRotator(numToKeepStr:'10'))
//     timeout(time: 5, unit: 'MINUTES')
//     ansiColor('xterm')
//   }

//   parameters{
//     choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy')
//     choice(name: 'AzureEnv', choices: 'dev\nprod')
//     string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
//   }

//   stages {  

//     stage('Init') {
//       steps {
//         withCredentials(
//           [
//             string(credentialsId: 'CLIENT_ID', variable: 'ARM_CLIENT_ID'),
//             string(credentialsId: 'CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
//             string(credentialsId: 'TENANT_ID', variable: 'ARM_TENANT_ID'),
//             string(credentialsId: 'HUB_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
//             string(credentialsId: 'SPOKE_SUBSCRIPTION_ID', variable: 'TF_VAR_SUBSCRIPTION_ID')
//           ]
//         ) {
//           script {
//             if ( AzureEnv.equals("dev") ) {
//               sh '''
//                 az account clear
//                 az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
//                 az account set -s $ARM_SUBSCRIPTION_ID
//                 az account show
//                 printenv
//                 terraform init
//               '''   
//             }
//             else {
//               sh '''
//                 az account clear
//                 az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
//                 az account set -s $TF_VAR_SUBSCRIPTION_ID
//                 az account show
//                 terraform init
//               '''                 
//             }
//           }
//         }
//       }
//     }

//     stage('Plan') {
//       steps {
//         withCredentials(
//           [
//             string(credentialsId: 'CLIENT_ID', variable: 'ARM_CLIENT_ID'),
//             string(credentialsId: 'CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
//             string(credentialsId: 'TENANT_ID', variable: 'ARM_TENANT_ID'),
//             string(credentialsId: 'HUB_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
//             string(credentialsId: 'SPOKE_SUBSCRIPTION_ID', variable: 'TF_VAR_SUBSCRIPTION_ID')
//           ]
//         ) {
//           script {
//             if ( AzureEnv.equals("dev") && Terraform_Command.equals("Terraform Plan") ) {
//               sh '''
//                 az account clear
//                 az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
//                 az account set -s $ARM_SUBSCRIPTION_ID
//                 az account show
//                 terraform plan -var Environment=$AzureEnv
//               '''   
//             }
//             else {
//               sh '''
//                 az account clear
//                 az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
//                 az account set -s $TF_VAR_SUBSCRIPTION_ID
//                 az account show
//                 terraform plan -var Environment=$AzureEnv
//               '''                
//             }
//           }
//         }
//       }
//     }    

//   }    
// }

node {
    withCredentials ([
      string(credentialsId: 'CLIENT_ID', variable: 'ARM_CLIENT_ID'),
      string(credentialsId: 'CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET'),
      string(credentialsId: 'TENANT_ID', variable: 'ARM_TENANT_ID'),
      string(credentialsId: 'HUB_SUBSCRIPTION_ID', variable: 'ARM_SUBSCRIPTION_ID'),
      string(credentialsId: 'SPOKE_SUBSCRIPTION_ID', variable: 'TF_VAR_SUBSCRIPTION_ID')
    ])
    {
        ansiColor('xterm') {

             stage ('Init') {
                 script {
                    if ( Environment.equals("dev") && Terraform_Command.equals("Terraform Plan") ) {
                      sh '''
                        az account clear
                        az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
                        az account set -s $ARM_SUBSCRIPTION_ID
                        az account show
                        terraform plan -var Environment=$Environment
                      '''   
                    }
                    else {
                      sh '''
                        az account clear
                        az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
                        az account set -s $TF_VAR_SUBSCRIPTION_ID
                        az account show
                        terraform plan -var Environment=$Environment
                      '''                
                    }
                 }
             }

            //  stage ('Plan') {
            //     if ( Terraform_Command.equals("Terraform Plan") ) {
            //         script {
            //             sh 'terraform plan'
            //         }
            //     }
            //  }

            //  stage ('Apply') {
            //     if ( Terraform_Command.equals("Terraform Apply") ) {
            //         script {
            //             sh 'terraform apply --auto-approve'
            //         }
            //     }
            //  }

            //  stage ('Destroy') {
            //     if ( Terraform_Command.equals("Terraform Destroy") && Destroy.equalsIgnoreCase("destroy") ) {
            //         script {
            //             sh 'terraform destroy --auto-approve'
            //         }
            //     }
            //  }

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
