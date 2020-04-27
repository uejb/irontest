<#ftl encoding='UTF-8'>

<#assign teststep = stepRun.teststep>
<#assign apiRequest = teststep.apiRequest>
<#if teststep.endpoint??>  <#-- not all test steps have endpoint (e.g. Wait step) -->
  <#assign endpoint = teststep.endpoint>
  <#assign endpointProperties = endpoint.otherProperties>
</#if>

<div class="row" id="step-run-${ stepRun.id?string.computer }">
  <div class="col-lg-11"><h4>${ teststep.name }</h4></div>
  <#if testcaseRun??>
    <div class="col-lg-1"><a href="#page-top">Top</a></div>
  </#if>
</div>

<div class="row">
  <div class="col-lg-1">Result:</div>
  <div class="col-lg-1 test-result-color-${stepRun.result}">${stepRun.result}</div>
  <div class="col-lg-1">Start Time:</div>
  <div class="col-lg-3">${ stepRun.startTime?datetime }</div>
  <div class="col-lg-1">Duration:</div>
  <div class="col-lg-1">${ stepRun.duration } ms</div>
</div>

<#if teststep.description?? && teststep.description?has_content>
  <div class="row">
    <div class="col-lg-1">Description:</div>
    <div class="col-lg-11">${ teststep.description }</div>
  </div>
</#if>

<div class="row">
  <div class="col-lg-1">Action:</div>
  <div class="col-lg-11">
    <#include "${teststep.type?lower_case}TeststepActionDescription.ftl">
  </div>
</div>

<#-- Error info -->
<#if stepRun.errorMessage??>
  <div class="row">
    <div class="col-lg-1">Error:</div>
    <div class="col-lg-11">${stepRun.errorMessage}</div>
  </div>
</#if>

<#-- Request, Response, and Assertions info -->
<#assign teststepTypes = ["HTTP", "SOAP", "FTP", "DB", "MQ", "AMQP"]>
<#if teststepTypes?seq_contains(teststep.type) && !(teststep.type == 'MQ' && teststep.action == 'Clear')>
  <div class="form-group"></div> <#-- spacer -->

  <#assign hasRequestTab = !(teststep.type == 'MQ' && (teststep.action == 'CheckDepth' || teststep.action == 'Dequeue'))>
  <#assign hasResponseAndAssertionsTabs = !(teststep.type == 'MQ' && (teststep.action == 'Enqueue' || teststep.action == 'Publish')) &&
    !(teststep.type == 'AMQP') && !(teststep.type == 'FTP')>
  <div>
    <#-- Nav tabs -->
    <ul class="nav nav-tabs tabs-in-test-report" role="tablist">
      <#-- use data-target attribute instead of href attribute on the anchor elements, to avoid spoiling routes of
        angular app on the test case edit view. Refer to https://stackoverflow.com/questions/19225968/bootstrap-tab-is-not-working-when-tab-with-data-target-instead-of-href for more details -->
      <#if hasRequestTab>
        <li role="presentation" ${ (hasResponseAndAssertionsTabs)?then('', 'class=active') }><a data-target="#step-run-${ stepRun.id?string.computer }-request" aria-controls="request" role="tab" data-toggle="tab">Request</a></li>
      </#if>
      <#if hasResponseAndAssertionsTabs>
        <#-- set Response tab to be active as response is the most interesting information -->
        <li role="presentation" class="active"><a data-target="#step-run-${ stepRun.id?string.computer }-response" aria-controls="response" role="tab" data-toggle="tab">Response</a></li>
        <li role="presentation"><a data-target="#step-run-${ stepRun.id?string.computer }-assertions" aria-controls="assertions" role="tab" data-toggle="tab">Assertions</a></li>
      </#if>
    </ul>

    <#-- Tab panes -->
    <div class="tab-content" id="request-response-assertions-tab-panes">
      <#if hasRequestTab>
        <div role="tabpanel" class="tab-pane ${ (hasResponseAndAssertionsTabs)?then('', 'active') }" id="step-run-${ stepRun.id?string.computer }-request">
          <#include "teststepRequest.ftl">
        </div>
      </#if>
      <#if hasResponseAndAssertionsTabs>
        <div role="tabpanel" class="tab-pane active" id="step-run-${ stepRun.id?string.computer }-response">
          <#include "teststepResponse.ftl">
        </div>
        <div role="tabpanel" class="tab-pane" id="step-run-${ stepRun.id?string.computer }-assertions">
          <#include "teststepAssertions.ftl">
        </div>
      </#if>
    </div>
  </div>
</#if>

<#if stepRun.teststep.type == "HTTPStubRequestsCheck" && stepRun.response??>
  <div class="row">
    <div class="col-lg-1" id="stub-requests-in-step-run-${ stepRun.id?string.computer }">Stub Requests</div>
    <div class="col-lg-11">
      <#t><#include "${teststep.type?lower_case}TeststepResponse.ftl">
    </div>
  </div>
</#if>

<#-- Some additional info about the step run -->
<#if stepRun.infoMessage??>
  <div class="row">
    <div class="col-lg-1">Info:</div>
    <div class="col-lg-11">${stepRun.infoMessage}</div>
  </div>
</#if>
