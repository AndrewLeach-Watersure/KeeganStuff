Ext.define('EAM.custom.external_wscrew', {
 extend: 'EAM.custom.AbstractExtensibilityFramework',
 getSelectors: function() {
 return {
 '[ExtensibilityFramework] [tabName=HDR][isTabView=true]
[name=description]': {
 before_eam_customonblur: function() {
 // This code executes before the form specific
organization change code executes
 // return false in this method to prevent the actual
form specific code from executing

 },
 customonblur: function() {
 // This code executes after the form specific
organization change cod executes
 // Do some follow up processing
 }
 },
'[ExtensibilityFramework] [tabName=HDR][isTabView=true]': {
 before_eam_beforesaverecord: function() {
 // This code executes before the form specific
'beforesaverecord' checks run
 // return false in this method to prevent the actual form
specific code from executing
 },
 beforesaverecord: function() {
 // This code executes after the form specific 'beforesaverecord'
checks run
 // return false in this method to prevent the actual save from
occurring
EAM.Utils.debugMessage('before_eam_beforesaverecord');
 },
 before_eam_aftersaverecord: function() {
 // This code executes before the form specific 'aftersaverecord'
follow up code runs
 // return false to prevent the actual form specific code from
executing
 },
 aftersaverecord: function() {
 // This code executes after the form specific 'aftersaverecord'
follow up code runs
 }
 },
 // Web Service Prompt tab
 '[ExtensibilityFramework]
[tabName=Y1][isTabView=true][userFunction=WSCREW]': {
 // do stuff
 }
 }
 }
 });
