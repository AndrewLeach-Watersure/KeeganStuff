Ext.define('EAM.custom.external_tutst1', {
	extend: 'EAM.custom.AbstractExtensibleFramework',
	getSelectors: function () {
		var me = this;
		return {
			'[extensibleFramework] [tabName=HDR] [name=wspf_10_aln1]' : {
				blur: function(field, lastValues) {
					var vField = field.getValue(),
					vFormPanel = field.formPanel;
						if (vField == 'Confimed'){
						vFormPanel.setFldValue('wspf_10_aln2', 'Success');
						}
						if (vField == 'dialog'){
						me.myDialog();
						}
						if (vField == 'Critical'){
						me.myWindow();
						}	
				}
			}
		}
	},

	
	myWindow: function() {
	//var myWin = Ext.create('Ext.window.Window', {
	var btnConfirm = new Ext.Button({
		text: 'Confirm',
		style: 'margin-right:40px;padding:15px;',
		tooltip: 'Confirm the Radio Selections',
		listeners: {
			click: function() {
				 	var rb1 = myWin.getComponent('radioset1').getComponent('EMNO');
					var rb2 = myWin.getComponent('radioset1').getComponent('EMYES');
					var rb1val = rb1.getValue();
					var rb2val = rb2.getValue();
					console.log('No ' + rb1 + ' ' + rb1val);
					console.log('Yes ' + rb2 + ' ' +rb2val);
					if (rb2val == true)
					{
							console.log('Inside If Statement');
							var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel()
							vFormPanel.setFldValue('wspf_10_check1','-1');
							myWin.destroy();
					}						
			}
		}
	});
	
	var btnCancel = new Ext.Button({
			text: 'Cancel',
			style: 'margin-left:40px;padding:15px;',
			listeners: {
				click: function() {
					myWin.destroy();
						}
			}
	});
	
	var myWin = new Ext.Window({
			title: 'Select a value',
			height: 350,
			width: 700,
			closable: true,
			bodyPadding: 10,
			items:[{
				xtype: 'radiogroup',
				fieldLabel: 'Emergency?',
				layout: 'hbox',
				itemId: 'radioset1',
				items: [
					{ itemId: 'EMNO', boxLabel: 'No', name: 'EM', inputValue: '1', checked: true},
					{ itemId: 'EMYES', boxLabel: 'Yes', name: 'EM', inputValue: '2' }]
				  }],
			buttons: [btnConfirm, btnCancel],
			buttonAlign: 'center',
			modal: true
	});
	//var rb1 = myWin.getComponent('EMNO');
	//var rb2 = myWin.getComponent('EMYES');
	myWin.show();
	}
 });