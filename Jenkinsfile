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

  stages {

    stage("Getting Environment Variables") {
      steps {
        script {
          if (Environment.equals("dev")) {
            K = credentials("HUB_SUBSCRIPTION_ID")
            L = credentials("TENANT_ID")
            M = credentials("CLIENT_ID")
            N = credentials("CLIENT_SECRET")             
          }
          else if (Environment.equals("prod")) {
            W = credentials("HUB_SUBSCRIPTION_ID")
            X = credentials("TENANT_ID")
            Y = credentials("CLIENT_ID")
            Z = credentials("CLIENT_SECRET")   
          }  
        }
      }
    }

    stage("Setting Environment Variables") {
      environment {
        ARM_SUBSCRIPTION_ID = credentials("HUB_SUBSCRIPTION_ID")
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
                echo $ARM_SUBSCRIPTION_ID
                terraform init
              '''          
            }
          }
        }

        stage ('Plan') {
          when {
            expression { Terraform_Command.equals("Terraform Plan") }
          }      
          steps {
            script {
              sh '''
                terraform plan -var Environment=$Environment
              '''          
            }
          }
        }

      }    
    }
  }
}

// Working Pipeline -1
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

//     stage("Environment") {
//       environment {
//         ARM_SUBSCRIPTION_ID = credentials("HUB_SUBSCRIPTION_ID")
//         ARM_TENANT_ID       = credentials("TENANT_ID")
//         ARM_CLIENT_ID       = credentials("CLIENT_ID")
//         ARM_CLIENT_SECRET   = credentials("CLIENT_SECRET")         
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


// import org.jenkinsci.plugins.pipeline.modeldefinition.Utils

// genericPipeline {

//   jobProperties.add(
//     parameters ([
//       choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy'),
//       choice(name: 'Environment', choices: 'dev\nprod'),
//       string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
//     ])
//   )

//   config = [
//     "dev": [
//       ARM_SUBSCRIPTION_ID : credentials("HUB_SUBSCRIPTION_ID"),
//       ARM_TENANT_ID       : credentials("TENANT_ID"),
//       ARM_CLIENT_ID       : credentials("CLIENT_ID"),
//       ARM_CLIENT_SECRET   : credentials("CLIENT_SECRET")
//     ],
//     "prod": [
//       ARM_SUBSCRIPTION_ID : credentials("SPOKE_SUBSCRIPTION_ID"),
//       ARM_TENANT_ID       : credentials("TENANT_ID"),
//       ARM_CLIENT_ID       : credentials("CLIENT_ID"),
//       ARM_CLIENT_SECRET   : credentials("CLIENT_SECRET")
//     ],
//   ]

//   //Environment         = env.Environment ? env.Environment : "dev"
//   ARM_SUBSCRIPTION_ID = env.ARM_SUBSCRIPTION_ID ? config.find{ it.key == env.ARM_SUBSCRIPTION_ID }?.value.ARM_SUBSCRIPTION_ID : config["dev"].ARM_SUBSCRIPTION_ID
//   ARM_TENANT_ID = env.ARM_TENANT_ID ? config.find{ it.key == env.ARM_TENANT_ID }?.value.ARM_TENANT_ID : config["dev"].ARM_TENANT_ID
//   ARM_CLIENT_ID = env.ARM_CLIENT_ID ? config.find{ it.key == env.ARM_CLIENT_ID }?.value.ARM_CLIENT_ID : config["dev"].ARM_CLIENT_ID
//   ARM_CLIENT_SECRET = env.ARM_CLIENT_SECRET ? config.find{ it.key == env.ARM_CLIENT_SECRET }?.value.ARM_CLIENT_SECRET : config["dev"].ARM_CLIENT_SECRET

//   terraformInitCommand = {
//           withEnv(["Environment=${Environment}",
//                     "ARM_SUBSCRIPTION_ID=${env.ARM_SUBSCRIPTION_ID}",
//                     "ARM_TENANT_ID=${env.ARM_TENANT_ID}",
//                     "ARM_CLIENT_ID=${ARM_CLIENT_ID}",
//                     "ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}"
//           ]) {
//               sh '''
//                 az account clear
//                 az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
//                 az account set -s $ARM_SUBSCRIPTION_ID
//                 az account show
//                 printenv
//                 terraform init
//               '''
//             }
//   }

// }  



//Backup

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

//   environment {
//     ARM_SUBSCRIPTION_ID = credentials("HUB_SUBSCRIPTION_ID")
//     ARM_TENANT_ID       = credentials("TENANT_ID")
//     ARM_CLIENT_ID       = credentials("CLIENT_ID")
//     ARM_CLIENT_SECRET   = credentials("CLIENT_SECRET")
//   }

//   stages {

//     stage ('Init') {
//       steps {
//         script {
//           sh '''
//             az account clear
//             az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET -t $ARM_TENANT_ID
//             az account set -s $ARM_SUBSCRIPTION_ID
//             az account show
//             printenv
//             terraform init
//           '''          
//         }
//       }
//     }

//     stage ('Plan') {
//       when {
//         expression { Terraform_Command.equals("Terraform Plan") }
//       }      
//       steps {
//         script {
//           sh '''
//             terraform plan
//           '''          
//         }
//       }
//     }    

//   }
// }




