<?xml version='1.0' encoding='UTF-8'?>
<hudson>
  <disabledAdministrativeMonitors/>
  <version>2.7.4</version>
  <numExecutors>5</numExecutors>
  <mode>NORMAL</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class="hudson.security.GlobalMatrixAuthorizationStrategy">
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Create:admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Create:developer-admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Delete:admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Delete:developer-admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains:admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains:developer-admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Update:admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Update:developer-admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.View:admin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.View:developer-admin</permission>
    <permission>hudson.model.Computer.Build:admin</permission>
    <permission>hudson.model.Computer.Build:developer-admin</permission>
    <permission>hudson.model.Computer.Configure:admin</permission>
    <permission>hudson.model.Computer.Configure:developer-admin</permission>
    <permission>hudson.model.Computer.Connect:admin</permission>
    <permission>hudson.model.Computer.Connect:developer-admin</permission>
    <permission>hudson.model.Computer.Create:admin</permission>
    <permission>hudson.model.Computer.Create:developer-admin</permission>
    <permission>hudson.model.Computer.Delete:admin</permission>
    <permission>hudson.model.Computer.Delete:developer-admin</permission>
    <permission>hudson.model.Computer.Disconnect:admin</permission>
    <permission>hudson.model.Computer.Disconnect:developer-admin</permission>
    <permission>hudson.model.Hudson.Administer:admin</permission>
    <permission>hudson.model.Hudson.Administer:developer-admin</permission>
    <permission>hudson.model.Hudson.Read:admin</permission>
    <permission>hudson.model.Hudson.Read:developer-admin</permission>
    <permission>hudson.model.Item.Build:admin</permission>
    <permission>hudson.model.Item.Build:developer-admin</permission>
    <permission>hudson.model.Item.Cancel:admin</permission>
    <permission>hudson.model.Item.Cancel:developer-admin</permission>
    <permission>hudson.model.Item.Configure:admin</permission>
    <permission>hudson.model.Item.Configure:developer-admin</permission>
    <permission>hudson.model.Item.Create:admin</permission>
    <permission>hudson.model.Item.Create:developer-admin</permission>
    <permission>hudson.model.Item.Delete:admin</permission>
    <permission>hudson.model.Item.Delete:developer-admin</permission>
    <permission>hudson.model.Item.Discover:admin</permission>
    <permission>hudson.model.Item.Discover:developer-admin</permission>
    <permission>hudson.model.Item.Move:admin</permission>
    <permission>hudson.model.Item.Move:developer-admin</permission>
    <permission>hudson.model.Item.Read:admin</permission>
    <permission>hudson.model.Item.Read:developer-admin</permission>
    <permission>hudson.model.Item.Workspace:admin</permission>
    <permission>hudson.model.Item.Workspace:developer-admin</permission>
    <permission>hudson.model.Run.Delete:admin</permission>
    <permission>hudson.model.Run.Delete:developer-admin</permission>
    <permission>hudson.model.Run.Replay:admin</permission>
    <permission>hudson.model.Run.Replay:developer-admin</permission>
    <permission>hudson.model.Run.Update:admin</permission>
    <permission>hudson.model.Run.Update:developer-admin</permission>
    <permission>hudson.model.View.Configure:admin</permission>
    <permission>hudson.model.View.Configure:developer-admin</permission>
    <permission>hudson.model.View.Create:admin</permission>
    <permission>hudson.model.View.Create:developer-admin</permission>
    <permission>hudson.model.View.Delete:admin</permission>
    <permission>hudson.model.View.Delete:developer-admin</permission>
    <permission>hudson.model.View.Read:admin</permission>
    <permission>hudson.model.View.Read:developer-admin</permission>
    <permission>hudson.scm.SCM.Tag:admin</permission>
    <permission>hudson.scm.SCM.Tag:developer-admin</permission>
    <permission>jenkins.metrics.api.Metrics.HealthCheck:admin</permission>
    <permission>jenkins.metrics.api.Metrics.HealthCheck:developer-admin</permission>
    <permission>jenkins.metrics.api.Metrics.ThreadDump:admin</permission>
    <permission>jenkins.metrics.api.Metrics.ThreadDump:developer-admin</permission>
    <permission>jenkins.metrics.api.Metrics.View:admin</permission>
    <permission>jenkins.metrics.api.Metrics.View:developer-admin</permission>
  </authorizationStrategy>
  <securityRealm class="hudson.security.HudsonPrivateSecurityRealm">
    <disableSignup>true</disableSignup>
    <enableCaptcha>false</enableCaptcha>
  </securityRealm>
  <disableRememberMe>false</disableRememberMe>
  <workspaceDir>${ITEM_ROOTDIR}/workspace</workspaceDir>
  <buildsDir>${ITEM_ROOTDIR}/builds</buildsDir>
  <jdks/>
  <viewsTabBar class="hudson.views.DefaultViewsTabBar"/>
  <myViewsTabBar class="hudson.views.DefaultMyViewsTabBar"/>
  <clouds>
    ${KUBERNETES_CONFIG}
  </clouds>
  <quietPeriod>1</quietPeriod>
  <scmCheckoutRetryCount>0</scmCheckoutRetryCount>
  <views>
    <hudson.model.AllView>
      <owner class="hudson" reference="../../.."/>
      <name>All</name>
      <filterExecutors>false</filterExecutors>
      <filterQueue>false</filterQueue>
      <properties/>
    </hudson.model.AllView>
  </views>
  <primaryView>All</primaryView>
  <slaveAgentPort>${JNLP_PORT}</slaveAgentPort>
  <label>master</label>
  <nodeProperties/>
  <globalNodeProperties>
    <hudson.slaves.EnvironmentVariablesNodeProperty>
      <envVars serialization="custom">
        <unserializable-parents/>
        <tree-map>
          <default>
            <comparator class="hudson.util.CaseInsensitiveComparator"/>
          </default>
          <int>2</int>
          <string>JENKINS_MASTER_URL</string>
          <string>${JENKINS_MASTER_URL}</string>
          <string>JSWARM_EXTRA_ARGS</string>
          <string>${JSWARM_EXTRA_ARGS}</string>
        </tree-map>
      </envVars>
    </hudson.slaves.EnvironmentVariablesNodeProperty>
  </globalNodeProperties>
  <noUsageStatistics>true</noUsageStatistics>
</hudson>