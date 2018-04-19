def username = 'developer-admin'
def credentialName = 'jenkins-slave-credentials'
def credentialDesc = 'Credentials used by multiarch-ci-libraries to connect provisioned hosts to Jenkins'

import hudson.model.*
import jenkins.security.ApiTokenProperty
import hudson.util.Secret
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*

// Get the actual token
u = User.get(username)
tokProp =  u.getProperty(ApiTokenProperty.class)
token = tokProp.getApiTokenInsecure()

// Get system credentials
domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// Add the new credentials to the global scope
credentials = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL,
  credentialName,
  credentialDesc,
  username,
  token
)

store.addCredentials(domain, credentials)
