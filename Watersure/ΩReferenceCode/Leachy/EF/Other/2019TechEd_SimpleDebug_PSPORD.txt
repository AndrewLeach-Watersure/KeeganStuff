Ext.define('EAM.custom.external_pspord', {
    extend: 'EAM.custom.AbstractExtensibleFramework',
    getSelectors: function() {
       return {
        '[extensibleFramework] [tabName=HDR][isTabView=true] [name=duedate]':{
					blur: function(field, lastValues){
						var vField = field.getValue(),
							vFormPanel = field.formPanel;
							console.log('inside field change')
							alert('PO Field Changed');
						}
					},
		'[extensibleFramework] [tabName=HDR]': {
                beforesaverecord: function() {
                    EAM.Utils.debugMessage('beforesave');
                },
                aftersaverecord: function() {
                    EAM.Utils.debugMessage('aftersave');
                },
                beforedestroyrecord: function() {
                    EAM.Utils.debugMessage('beforedestroy');
                },
                afterdestroyrecord: function() {
                    EAM.Utils.debugMessage('afterdestroy');
                },
                beforenewrecord: function() {
                    EAM.Utils.debugMessage('beforenew_hdr');
                    return false;
                },
                afternewrecord: function() {
                    EAM.Utils.debugMessage('afternew_hdr');
                }
            }
		}
    }
});