import hudson.model.*
import jenkins.model.*
import jenkins.security.*
import jenkins.security.csrf.DefaultCrumbIssuer
import hudson.util.Secret
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*

jenkins = Jenkins.instance
def logger = Logger.getLogger("")

logger.info("Enabling CSRF Protection")
jenkins.setCrumbIssuer(new DefaultCrumbIssuer(true))

logger.info("Disabling deprecated agent protocols (only JNLP4 is enabled)")
Set<String> agentProtocolsList = ['JNLP4-connect']
jenkins.setAgentProtocols(agentProtocolsList)

jenkins.save()

def username = 'developer-admin'
def credentialName = 'jenkins-slave-credentials'
def credentialDesc = 'Credentials used by multiarch-ci-libraries to connect provisioned hosts to Jenkins'

// Get the actual token
u = User.get(username)
tokProp =  u.getProperty(ApiTokenProperty.class)
token = tokProp.getApiTokenInsecure()

// Get system credentials
domain = Domain.global()
store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// Add the new credentials to the global scope
credentials = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL,
  credentialName,
  credentialDesc,
  username,
  token
)

logger.info("Adding developer-admin token as secret so that slaves can authenticate")
store.addCredentials(domain, credentials)

logger.info("Setting Time Zone to be EST")
System.setProperty('org.apache.commons.jelly.tags.fmt.timeZone', 'America/New_York')

