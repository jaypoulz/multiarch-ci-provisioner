<?xml version='1.0' encoding='UTF-8'?>
<hudson>
  <disabledAdministrativeMonitors/>
  <version>2.7.4</version>
  <numExecutors>5</numExecutors>
  <mode>NORMAL</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class="hudson.security.GlobalMatrixAuthorizationStrategy">
    <permission>hudson.model.Computer.Configure:admin</permission>
    <permission>hudson.model.Computer.Connect:developer-admin</permission>
    <permission>hudson.model.Computer.Delete:admin</permission>
    <permission>hudson.model.Hudson.Administer:admin</permission>
    <permission>hudson.model.Hudson.Read:admin</permission>
    <permission>hudson.model.Item.Build:admin</permission>
    <permission>hudson.model.Item.Configure:admin</permission>
    <permission>hudson.model.Item.Create:admin</permission>
    <permission>hudson.model.Item.Delete:admin</permission>
    <permission>hudson.model.Item.Read:admin</permission>
    <permission>hudson.model.Item.Workspace:admin</permission>
    <permission>hudson.model.Run.Delete:admin</permission>
    <permission>hudson.model.Run.Update:admin</permission>
    <permission>hudson.model.View.Configure:admin</permission>
    <permission>hudson.model.View.Create:admin</permission>
    <permission>hudson.model.View.Delete:admin</permission>
    <permission>hudson.scm.SCM.Tag:admin</permission>
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
