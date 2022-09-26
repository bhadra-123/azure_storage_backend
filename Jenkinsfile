pipeline {

  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr:'1'))
    timeout(time: 5, unit: 'MINUTES')
    ansiColor('xterm')
  }

  parameters{
    choice(name: 'Terraform_Command', choices: 'Terraform Plan\nTerraform Apply\nTerraform Destroy')
    choice(name: 'Azure_Environment', choices: 'dev\nqa\nprod')
    string(name: 'Destroy', defaultValue: '', description: 'Confirm Destroy by typing the word "destroy"' )
  }

  environment {
    TENANT_ID               = credentials("TENANT_ID")
    HUB_SUBSCRIPTION_ID     = credentials("HUB_SUBSCRIPTION_ID") 
    HUB_CLIENT_ID           = credentials("HUB_CLIENT_ID") 
    HUB_CLIENT_SECRET       = credentials("HUB_CLIENT_SECRET") 
    COMPUTE_SUBSCRIPTION_ID = credentials("COMPUTE_SUBSCRIPTION_ID") 
    COMPUTE_CLIENT_ID       = credentials("COMPUTE_CLIENT_ID") 
    COMPUTE_CLIENT_SECRET   = credentials("COMPUTE_CLIENT_SECRET")    
    SPOKE_SUBSCRIPTION_ID   = credentials("SPOKE_SUBSCRIPTION_ID")
    SPOKE_CLIENT_ID         = credentials("SPOKE_CLIENT_ID") 
    SPOKE_CLIENT_SECRET     = credentials("SPOKE_CLIENT_SECRET")
    GIT_URL                 = "https://github.com/bhadra-123/azure_storage_backend"
  }

  stages {

    stage('Secret ID') {
      steps {
        script {
          switch(Azure_Environment) {
            case "dev":
              SUBSCRIPTION_ID = "${HUB_SUBSCRIPTION_ID}"
              CLIENT_ID       = "${HUB_CLIENT_ID}"
              CLIENT_SECRET   = "${HUB_CLIENT_SECRET}"
            break            
            case "qa":
              SUBSCRIPTION_ID = "${COMPUTE_SUBSCRIPTION_ID}"
              CLIENT_ID       = "${COMPUTE_CLIENT_ID}"
              CLIENT_SECRET   = "${COMPUTE_CLIENT_SECRET}"
            break
            case "prod":
              SUBSCRIPTION_ID = "${SPOKE_SUBSCRIPTION_ID}"
              CLIENT_ID       = "${SPOKE_CLIENT_ID}"
              CLIENT_SECRET   = "${SPOKE_CLIENT_SECRET}"
            break        
            default:
              SUBSCRIPTION_ID = "${HUB_SUBSCRIPTION_ID}"
              CLIENT_ID       = "${HUB_CLIENT_ID}"
              CLIENT_SECRET   = "${HUB_CLIENT_SECRET}"
            break 
          }
        }
      }
    }

    stage('GIT Checkout') {
      steps {
        script {
          checkout([$class: 'GitSCM', branches: [[name: 'main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GITHUB_PAT_TOKEN', url: "${GIT_URL}"]]])
        }
      }
    }

    stage ('Alter tfvars') {
      steps {
        script {
          sh """
            cd ${workspace}/deployments/${Azure_Environment}
            echo Environment     = '"'${Azure_Environment}'"' >> ${Azure_Environment}.tfvars
            echo client_id       = '"'${CLIENT_ID}'"'         >> ${Azure_Environment}.tfvars
            echo client_secret   = '"'${CLIENT_SECRET}'"'     >> ${Azure_Environment}.tfvars
            echo subscription_id = '"'${SUBSCRIPTION_ID}'"'   >> ${Azure_Environment}.tfvars
            echo tenant_id       = '"'${TENANT_ID}'"'         >> ${Azure_Environment}.tfvars
            cat ${Azure_Environment}.tfvars
          """
        }
      }
    }

    stage ('Init') {
      steps {
        script {
          sh """
            terraform -chdir=${workspace}/deployments/${Azure_Environment} init -upgrade
          """   
        }
      }
    }

    stage ('Plan') {
      steps {
        script {
          if ( Terraform_Command.equals("Terraform Plan") ||  Terraform_Command.equals("Terraform Apply") || Terraform_Command.equals("Terraform Destroy") ) {
            sh """
              terraform -chdir=${workspace}/deployments/${Azure_Environment} plan \
                -var-file=${workspace}/deployments/${Azure_Environment}/${Azure_Environment}.tfvars \
                -out ${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_plan.txt
            """  
          } 
        }
      }
    }    

    stage ('Apply') {
      steps {
        script {
          if ( Terraform_Command.equals("Terraform Apply") ) {
            sh """
              terraform -chdir=${workspace}/deployments/${Azure_Environment} apply --auto-approve ${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_plan.txt
            """   
          }
        }
      }
    }

    stage ('Destroy') {
      steps {
        script {
          if ( Terraform_Command.equals("Terraform Destroy") && Destroy.equalsIgnoreCase("destroy") ) {
            sh """
              terraform -chdir=${workspace}/deployments/${Azure_Environment} plan -destroy \
                -var-file=${workspace}/deployments/${Azure_Environment}/${Azure_Environment}.tfvars \
                -out=${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_destroy.tfplan
              terraform apply --auto-approve ${workspace}/deployments/${Azure_Environment}/${Azure_Environment}_destroy.tfplan
            """   
          }
        }
      }
    }        

  }
}