<@amqpTeststepActionDescription teststep = stepRun.teststep/>

<#macro amqpTeststepActionDescription teststep>
  <#local stepOtherProperties = teststep.otherProperties>
  Send message to target "${ stepOtherProperties.nodeAddress }" at AMQP service URI "${ teststep.endpoint.url }".
</#macro>