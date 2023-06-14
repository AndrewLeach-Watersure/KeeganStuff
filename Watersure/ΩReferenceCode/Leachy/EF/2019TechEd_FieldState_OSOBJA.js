	Ext.define('EAM.custom.external_osobja', {
		extend: 'EAM.custom.AbstractExtensibleFramework',
		getSelectors: function() {
			return {
				'[extensibleFramework] [tabName=HDR][isTabView=true] [name=udfchar08]':{
					blur: function(field, lastValues){
						var vField = field.getValue(),
							vFormPanel = field.formPanel;
						
						if (vField == 'POPULATED'){
							vFormPanel.setFldValue('udfchar09', 'Success');
						}
						if (Ext.isEmpty(vField)){
							vFormPanel.setFldValue('udfchar09', 'Empty');
						}
						if (vField == 'YELLOW'){
						document.getElementsByName('udfchar09')[0].style.backgroundColor="YELLOW";
						}
						if (vField == 'RED'){
						document.getElementsByName('udfchar09')[0].style.backgroundColor="RED";
						}
						if (vField == 'WHITE'){
						document.getElementsByName('udfchar09')[0].style.backgroundColor="WHITE";
						}
						if (vField == 'WHITE'){
						document.getElementsByName('udfchar09')[0].style.backgroundColor="WHITE";
						}
						if (vField == 'ITALIC'){
						document.getElementsByName('udfchar09')[0].style.fontStyle="ITALIC";
						}
						if (vField == 'NORMAL'){
						document.getElementsByName('udfchar09')[0].style.fontStyle="NORMAL";
						}
						if (vField == 'BOLD'){
						document.getElementsByName('udfchar09')[0].style.fontWeight='BOLD';
						}
						if (vField == 'WINGDINGS'){
						document.getElementsByName('udfchar09')[0].style.fontFamily="WINGDINGS";
						}
						if (vField == 'CALIBRI'){
						document.getElementsByName('udfchar09')[0].style.fontFamily="CALIBRI";
						}
						if (vField == 'NORMAL'){
						document.getElementsByName('udfchar09')[0].style.fontFamily="NORMAL";
						}							
						if(vField == 'OPTIONAL'){						EAM.Builder.setFieldState({'udfchar09':'optional'},vFormPanel.getForm().getFieldsAndButtons());
						}
						if(vField == 'PROTECTED'){						EAM.Builder.setFieldState({'udfchar09':'protected'},vFormPanel.getForm().getFieldsAndButtons());
						}
						if(vField == 'REQUIRED'){						EAM.Builder.setFieldState({'udfchar09':'required'},vFormPanel.getForm().getFieldsAndButtons());
						}
						if(vField == 'HIDDEN'){						EAM.Builder.setFieldState({'udfchar09':'hidden'},vFormPanel.getForm().getFieldsAndButtons());
						}
						if(vField == 'LOG'){						
						console.log('This is us logging to the console');
						}
						if(vField == 'RED HEADER'){
						Ext.select('span.recordcode').applyStyles({
						color: '#ff0000',
						fontWeight: 'bold'
						});
						Ext.select('span.recorddesc').applyStyles({
						color: '#ff0000',
						fontWeight: 'bold'
						});
						}
	
						if(vField == 'INFO'){
							 EAM.MsgBox.show({
								msgs : [{
								type : 'info',
								msg : EAM.Lang.getCustomFrameworkMessage('INFO Message Box')
								}],
								buttons : EAM.MsgBox.OKCANCEL
								});
							}
						if(vField == 'WARN'){
							 EAM.MsgBox.show({
								msgs : [{
								type : 'warning',
								msg : EAM.Lang.getCustomFrameworkMessage('WARN Message Box')
								}],
								buttons : EAM.MsgBox.OKCANCEL
								});
							}
						if(vField == 'ERROR'){
							 EAM.MsgBox.show({
								msgs : [{
								type : 'error',
								msg : EAM.Lang.getCustomFrameworkMessage('ERROR Message Box')
								}],
								buttons : EAM.MsgBox.OKCANCEL
								});
							}
						if(vField == 'ALERT'){alert('this is an EAM Alert');
						}
	
					}
				}
			}
		}
	})