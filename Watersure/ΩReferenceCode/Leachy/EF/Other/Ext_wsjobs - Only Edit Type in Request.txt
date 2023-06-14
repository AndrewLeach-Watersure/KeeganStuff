***Work Order type needs to be set to protected for all user groups***
***Need to add OR vStat == 'UNFI' as well.                         ***


Ext.define('EAM.custom.external_wsjobs', {
    extend: 'EAM.custom.AbstractExtensibleFramework',
getSelectors: function() {
       return {
         '[extensibleFramework] [tabName=HDR][isTabView=true]': {
                afterloaddata: function(formPanel) {
EAM.Utils.debugMessage('After Load Data');


var vStat = formPanel.getFldValue('workorderstatus');
EAM.Utils.debugMessage(vStat);
if (vStat == 'RQST')
{
EAM.Builder.setFieldState({'workordertype':'optional'},formPanel.getForm().getFieldsAndButtons());
}                          

}
},
         '[extensibleFramework] [tabName=HDR][isTabView=true] [name=workordertype]': {
                blur: function(field, lastValues) {
EAM.Utils.debugMessage('blur');
var vFormPanel = field.formPanel;
EAM.Utils.debugMessage('form Panel');
var vStat = vFormPanel.getFldValue('workorderstatus');
EAM.Utils.debugMessage(vStat);
if (vStat == 'RQST')
{
EAM.Builder.setFieldState({'workordertype':'optional'},vFormPanel.getForm().getFieldsAndButtons());
}                          

}
}
}
}
});