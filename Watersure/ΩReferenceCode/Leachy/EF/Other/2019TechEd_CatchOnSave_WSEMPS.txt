	Ext.define('EAM.custom.external_wsemps', {
		extend: 'EAM.custom.AbstractExtensibleFramework',
		getSelectors: function() {
			return {
				'[extensibleFramework] [tabName=HDR][isTabView=true]':{
					beforesaverecord: function(){
						var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
							vFieldOOS = vFormPanel.getFldValue('outofservice');
							vFieldTRD = vFormPanel.getFldValue('tradesperson');
						if(vFieldOOS == '-1' & vFieldTRD == '-1'){
							console.log('Inside If Statement');
							document.getElementsByName('tradesperson')[0].labels[0].style.fontWeight="BOLD";
							document.getElementsByName('tradesperson')[0].labels[0].style.fontStyle="ITALIC";
							document.getElementsByName('tradesperson')[0].labels[0].style.fontStyle="ITALIC";
							document.getElementsByName('tradesperson')[0].labels[0].style.color="RED";
								EAM.MsgBox.show({
								msgs : [{
								type : 'error',
								msg : EAM.Lang.getCustomFrameworkMessage('Trades people cannot be marked out of service')
								}],
								buttons : EAM.MsgBox.OK
								});
								return false;
								
							}
					}
				}
			}
		}
	})