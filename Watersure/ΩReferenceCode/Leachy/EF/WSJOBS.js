Ext.define('EAM.custom.external_wsjobs', {
    extend: 'EAM.custom.AbstractExtensibleFramework',
getSelectors: function() {
       return {
         '[extensibleFramework] [tabName=HDR][isTabView=true] [name=workordertype]': {
                focus: function(field, lastValues) {
EAM.Utils.debugMessage('Focus');
var vFormPanel = field.formPanel,
vStat = vFormPanel.getFldValue('workorderstatus');
EAM.Utils.debugMessage(vStat);
if (vStat == 'RQST')
{
EAM.Builder.setFieldState({'workordertype':'optional'},vFormPanel.getForm().getFieldsAndButtons());
}                          
if (vStat !== 'RQST')
{
EAM.Builder.setFieldState({'workordertype':'protected'},vFormPanel.getForm().getFieldsAndButtons());
}                          
}
}
}
}
});