Ext.define('EAM.custom.external_UUCHV3', {
  extend: 'EAM.custom.AbstractExtensibleFramework',
  getSelectors: function() {
    return {
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_event]': {
        focus: function(field, lastValues) {
          var vFormPanel = field.formPanel,
            vWO = vFormPanel.getFldValue('wspf_10_cmf_event');
          EAM.Utils.debugMessage(vWO);
          if (vWO) {
            EAM.Builder.setFieldState({
              'wspf_10_cmf_event': 'protected'
            }, vFormPanel.getForm().getFieldsAndButtons());
          }
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_reqbrief]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vUser = gAppData.installParams.user,
            vCreator = vFormPanel.getForm().findField('wspf_10_cmf_creator').getValue(),
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_status'),
            vFlag = (vStatus === "Change Request") ? false : true,
            wspf_10_cmf_car = vFormPanel.getFldValue('wspf_10_cmf_car'),
            wspf_10_cmf_tempmodchbx = vFormPanel.getForm().findField("wspf_10_cmf_tempmodchbx").getValue(),
            wspf_10_cmf_permmodchbx = vFormPanel.getForm().findField("wspf_10_cmf_permmodchbx").getValue(),
            wspf_10_cmf_enginvchbx = vFormPanel.getForm().findField("wspf_10_cmf_enginvchbx").getValue(),
            wspf_10_cmf_need = vFormPanel.getFldValue('wspf_10_cmf_need'),
            wspf_10_cmf_aims = vFormPanel.getFldValue('wspf_10_cmf_aims'),
            wspf_10_cmf_roi = vFormPanel.getFldValue('wspf_10_cmf_roi'),
            wspf_10_cmf_indschedres = vFormPanel.getFldValue('wspf_10_cmf_indschedres'),
            wspf_10_cmf_stakeholders = vFormPanel.getFldValue('wspf_10_cmf_stakeholders'),
            wspf_10_cmf_engsummary = vFormPanel.getFldValue('wspf_10_cmf_engsummary'),
            wspf_10_cmf_cstlabour = vFormPanel.getFldValue('wspf_10_cmf_cstlabour'),
            wspf_10_cmf_cstmaterial = vFormPanel.getFldValue('wspf_10_cmf_cstmaterial'),
            wspf_10_cmf_cstother = vFormPanel.getFldValue('wspf_10_cmf_cstother'),
            wspf_10_cmf_csttotal = vFormPanel.getFldValue('wspf_10_cmf_csttotal'),
            wspf_10_cmf_invres = vFormPanel.getFldValue('wspf_10_cmf_invres'),
            wspf_10_cmf_investhrs = vFormPanel.getFldValue('wspf_10_cmf_investhrs'),
            wspf_10_cmf_invextcosts = vFormPanel.getFldValue('wspf_10_cmf_invextcosts'),
            wspf_10_cmf_riskops = vFormPanel.getForm().findField("wspf_10_cmf_riskops").getValue(),
            wspf_10_cmf_riskasset = vFormPanel.getForm().findField("wspf_10_cmf_riskasset").getValue(),
            wspf_10_cmf_risksafety = vFormPanel.getForm().findField("wspf_10_cmf_risksafety").getValue(),
            wspf_10_cmf_riskenviro = vFormPanel.getForm().findField("wspf_10_cmf_riskenviro").getValue(),
            wspf_10_cmf_riskstrat = vFormPanel.getForm().findField("wspf_10_cmf_riskstrat").getValue(),
            wspf_10_cmf_risktotal = vFormPanel.getFldValue('wspf_10_cmf_risktotal'),
            wspf_10_cmf_riskcomm = vFormPanel.getFldValue('wspf_10_cmf_riskcomm');
          EAM.Utils.debugMessage(vFlag);
          EAM.Utils.debugMessage(gAppData.installParams.user);
          var chbr = Ext.create('Ext.window.Window', {
            title: 'Change Management Form',
            modal: true,
            autoShow: true,
            height: 800,
            scrollable: 'true',
            width: 1200,
            bodyPadding: 10,
            maximizable: true,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                  xtype: 'fieldcontainer',
                  height: 40,
                  width: 1150,
                  fieldLabel: '',
                  layout: {
                    type: 'hbox',
                  },
                  items: [{
                      xtype: 'textfield',
                      flex: 1,
                      minWidth: 100,
                      labelStyle: 'font-weight:bold;',
                      value: wspf_10_cmf_car,
                      fieldLabel: 'CAR (Number)',
                      name: 'vwspf_10_cmf_car'
                    },
                    {
                      xtype: 'checkboxfield',
                      flex: 1,
                      fieldLabel: '',
                      padding: 10,
                      labelStyle: 'font-weight:bold;',
                      boxLabel: 'Temporary Modification',
                      value: wspf_10_cmf_tempmodchbx,
                      name: 'vwspf_10_cmf_tempmodchbx'
                    },
                    {
                      xtype: 'checkboxfield',
                      flex: 1,
                      fieldLabel: '',
                      padding: 10,
                      labelStyle: 'font-weight:bold;',
                      boxLabel: 'Permanent Modification',
                      value: wspf_10_cmf_permmodchbx,
                      name: 'vwspf_10_cmf_permmodchbx'
                    },
                    {
                      xtype: 'checkboxfield',
                      flex: 1,
                      fieldLabel: '',
                      padding: 10,
                      labelStyle: 'font-weight:bold;',
                      boxLabel: 'Engineering Investigation',
                      value: wspf_10_cmf_enginvchbx,
                      name: 'vwspf_10_cmf_enginvchbx'
                    }
                  ]
                },
                {
                  xtype: 'fieldcontainer',
                  height: '',
                  minWidth: 1000,
                  width: 1150,
                  layout: 'vbox',
                  fieldLabel: '',
                  defaults: {
                    height: 120,
                    width: 1150,
                    labelWidth: 200,
                    flex: 1,
                    labelStyle: 'font-weight:bold;',
                    xtype: 'textareafield'
                  },
                  items: [{
                      fieldLabel: 'Statement of Need/Benefit/ Reasons/Risks in this Project',
                      emptyText: '(What does the project want to achieve)',
                      value: wspf_10_cmf_need,
                      name: 'vwspf_10_cmf_need'
                    },
                    {
                      fieldLabel: 'Aims/Objectives',
                      emptyText: '(What issue does this project aim to address – what is the problem?)',
                      value: wspf_10_cmf_aims,
                      name: 'vwspf_10_cmf_aims'
                    },
                    {
                      fieldLabel: 'Return on Investment /Payback Period / Justification',
                      emptyText: '(Why are we doing this project?)',
                      value: wspf_10_cmf_roi,
                      name: 'vwspf_10_cmf_roi'
                    },
                    {
                      fieldLabel: 'Indicative Schedule & Resources to be used',
                      value: wspf_10_cmf_indschedres,
                      name: 'vwspf_10_cmf_indschedres'
                    },
                    {
                      fieldLabel: 'Interface/Relevant Stakeholders',
                      emptyText: '(List of stakeholder who need to be involved)',
                      value: wspf_10_cmf_stakeholders,
                      name: 'vwspf_10_cmf_stakeholders'
                    },
                    {
                      fieldLabel: 'Analysis of Options/Engineering Investigation/ Suggested Option',
                      emptyText: '(Summary of Engineering Investigation Actions,  if one has been performed)',
                      value: wspf_10_cmf_engsummary,
                      name: 'vwspf_10_cmf_engsummary'
                    }
                  ]
                },
                {
                  xtype: 'fieldcontainer',
                  width: 1150,
                  fieldLabel: 'Indicative Total Project Cost (If not known leave blank, if 0 leave 0)',
                  labelStyle: 'font-weight:bold;',
                  labelWidth: 200,
                  layout: {
                    type: 'hbox',
                    align: 'stretch',
                  },
                  defaults: {
                    xtype: 'numberfield',
                    labelStyle: 'font-weight:bold;',
                    labelAlign: 'right',
                    flex: 1,
                    padding: 10,
                    width: 50,
                    labelWidth: 70,
                  },
                  items: [{
                      fieldLabel: 'Labour $',
                      value: wspf_10_cmf_cstlabour,
                      name: 'vwspf_10_cmf_cstlabour'
                    },
                    {
                      fieldLabel: 'Material $',
                      value: wspf_10_cmf_cstmaterial,
                      name: 'vwspf_10_cmf_cstmaterial'
                    },
                    {
                      fieldLabel: 'Other $',
                      value: wspf_10_cmf_cstother,
                      name: 'vwspf_10_cmf_cstother'
                    },
                    {
                      fieldLabel: 'Total',
                      value: wspf_10_cmf_csttotal,
                      name: 'vwspf_10_cmf_csttotal'
                    }
                  ]
                },
                {
                  xtype: 'fieldcontainer',
                  height: 135,
                  labelStyle: 'font-weight:bold;',
                  fieldLabel: 'Initial Concept phase / Engineering Investigation Cost',
                  labelWidth: 200,
                  width: 1150,
                  layout: {
                    type: 'hbox',
                  },
                  defaults: {
                    xtype: 'textareafield',
                    flex: 1,
                    labelStyle: 'font-weight:bold;',
                    labelAlign: 'right',
                    width: 100,
                    height: 120,
                    padding: 10,
                    labelWidth: 75,
                  },
                  items: [{
                      fieldLabel: 'Resources (List)',
                      emptyText: '1: \n2: \n3:',
                      value: wspf_10_cmf_invres,
                      name: 'vwspf_10_cmf_invres'
                    },
                    {
                      fieldLabel: 'Estimate Hours',
                      emptyText: '1: \n2: \n3:',
                      value: wspf_10_cmf_investhrs,
                      name: 'vwspf_10_cmf_investhrs'
                    },
                    {
                      fieldLabel: 'External Costs',
                      emptyText: '(Company)',
                      value: wspf_10_cmf_invextcosts,
                      name: 'vwspf_10_cmf_invextcosts'
                    }
                  ],
                },
                {
                  xtype: 'fieldcontainer',
                  height: 50,
                  minWidth: 1150,
                  fieldLabel: 'Risk evaluation',
                  labelWidth: 200,
                  labelStyle: 'font-weight:bold;',
                  layout: {
                    type: 'hbox',
                    align: 'stretch',
                  },
                  defaults: {
                    labelStyle: 'font-weight:bold;',
                    xtype: 'checkboxfield',
                    flex: 1,
                    fieldLabel: '',
                    padding: 10,
                  },
                  items: [{
                      boxLabel: 'Operational',
                      value: wspf_10_cmf_riskops,
                      name: 'vwspf_10_cmf_riskops'

                    },
                    {
                      boxLabel: 'Asset',
                      value: wspf_10_cmf_riskasset,
                      name: 'vwspf_10_cmf_riskasset'

                    },
                    {
                      boxLabel: 'Safety',
                      value: wspf_10_cmf_risksafety,
                      name: 'vwspf_10_cmf_risksafety'
                    },
                    {
                      boxLabel: 'Environment',
                      value: wspf_10_cmf_riskenviro,
                      name: 'vwspf_10_cmf_riskenviro'
                    },
                    {
                      boxLabel: 'Strategic',
                      value: wspf_10_cmf_riskstrat,
                      name: 'vwspf_10_cmf_riskstrat'
                    }
                  ]
                },
                {
                  xtype: 'fieldcontainer',
                  height: '',
                  minWidth: 1150,
                  width: 1150,
                  layout: 'vbox',
                  fieldLabel: '',
                  defaults: {
                    height: 120,
                    labelStyle: 'font-weight:bold;',
                    width: 1150,
                    labelWidth: 200,
                    flex: 1,
                    xtype: 'textareafield'
                  },
                  items: [{
                      xtype: 'numberfield',
                      fieldLabel: 'Overall risk rating',
                      height: 40,
                      value: wspf_10_cmf_risktotal,
                      emptyText: '(Assign Priority via Risk Ranking Number)',
                      name: 'vwspf_10_cmf_risktotal'
                    },
                    {
                      fieldLabel: 'Risk Rating Comments',
                      value: wspf_10_cmf_riskcomm,
                      emptyText: '(RSK-000-FM-001  Revision 3.0 Risk Assessment Form)',
                      name: 'vwspf_10_cmf_riskcomm'
                    }
                  ],
                }
              ]
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              readOnly: vFlag,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                vFormPanel.setFldValue('wspf_10_cmf_car', values.vwspf_10_cmf_car, true),
                  vFormPanel.setFldValue('wspf_10_cmf_need', values.vwspf_10_cmf_need, true),
                  vFormPanel.setFldValue('wspf_10_cmf_aims', values.vwspf_10_cmf_aims, true),
                  vFormPanel.setFldValue('wspf_10_cmf_roi', values.vwspf_10_cmf_roi, true),
                  vFormPanel.setFldValue('wspf_10_cmf_indschedres', values.vwspf_10_cmf_indschedres, true),
                  vFormPanel.setFldValue('wspf_10_cmf_stakeholders', values.vwspf_10_cmf_stakeholders, true),
                  vFormPanel.setFldValue('wspf_10_cmf_engsummary', values.vwspf_10_cmf_engsummary, true),
                  vFormPanel.setFldValue('wspf_10_cmf_cstlabour', values.vwspf_10_cmf_cstlabour, true),
                  vFormPanel.setFldValue('wspf_10_cmf_cstmaterial', values.vwspf_10_cmf_cstmaterial, true),
                  vFormPanel.setFldValue('wspf_10_cmf_cstother', values.vwspf_10_cmf_cstother, true),
                  vFormPanel.setFldValue('wspf_10_cmf_csttotal', values.vwspf_10_cmf_csttotal, true),
                  vFormPanel.setFldValue('wspf_10_cmf_invres', values.vwspf_10_cmf_invres, true),
                  vFormPanel.setFldValue('wspf_10_cmf_investhrs', values.vwspf_10_cmf_investhrs, true),
                  vFormPanel.setFldValue('wspf_10_cmf_invextcosts', values.vwspf_10_cmf_invextcosts, true),
                  vFormPanel.getForm().findField("wspf_10_cmf_tempmodchbx").setValue(form.getForm().findField("vwspf_10_cmf_tempmodchbx").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_permmodchbx").setValue(form.getForm().findField("vwspf_10_cmf_permmodchbx").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_enginvchbx").setValue(form.getForm().findField("vwspf_10_cmf_enginvchbx").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_riskops").setValue(form.getForm().findField("vwspf_10_cmf_riskops").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_riskasset").setValue(form.getForm().findField("vwspf_10_cmf_riskasset").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_risksafety").setValue(form.getForm().findField("vwspf_10_cmf_risksafety").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_riskenviro").setValue(form.getForm().findField("vwspf_10_cmf_riskenviro").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_riskstrat").setValue(form.getForm().findField("vwspf_10_cmf_riskstrat").getValue()),
                  vFormPanel.setFldValue('wspf_10_cmf_risktotal', values.vwspf_10_cmf_risktotal, true),
                  vFormPanel.setFldValue('wspf_10_cmf_riskcomm', values.vwspf_10_cmf_riskcomm, true);
                document.getElementById('action').value = 'UPDATE'  
                win.close();
              }
            }]
          }).show();
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_chappr]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vUser = gAppData.installParams.user,
            vOwner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_status'),
            vFlag = false, // (vStatus === "Change Request") ? false : true,
            wspf_10_cmf_eicomm = vFormPanel.getFldValue('wspf_10_cmf_eicomm'),
            wspf_10_cmf_mechcomm = vFormPanel.getFldValue('wspf_10_cmf_mechcomm'),
            wspf_10_cmf_plantcomm = vFormPanel.getFldValue('wspf_10_cmf_plantcomm'),
            wspf_10_cmf_safecomm = vFormPanel.getFldValue('wspf_10_cmf_safecomm'),
            wspf_10_cmf_mancomm = vFormPanel.getFldValue('wspf_10_cmf_mancomm'),
            wspf_10_cmf_owner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            wspf_10_cmf_invappcst = vFormPanel.getFldValue('wspf_10_cmf_invappcst'),
            wspf_10_cmf_engauth = vFormPanel.getFldValue('wspf_10_cmf_engauth'),
            wspf_10_cmf_extengreview = vFormPanel.getFldValue('wspf_10_cmf_extengreview'),
            wspf_10_cmf_custrep = vFormPanel.getFldValue('wspf_10_cmf_custrep'),
            wspf_10_cmf_chflow = vFormPanel.getFldValue('wspf_10_cmf_chflow');
          var chapp = Ext.create('Ext.window.Window', {
            title: 'Change Management Approval',
            modal: true,
            autoShow: true,
            flex: 1,
            height: 800,
            scrollable: 'true',
            width: 1200,
            maximizable: true,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            bodyPadding: 10,
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                  xtype: 'fieldcontainer',
                  width: 1200,
                  layout: 'vbox',
                  fieldLabel: '',
                  defaults: {
                    height: 120,
                    width: 1150,
                    labelWidth: 200,
                    flex: 1,
                    labelStyle: 'font-weight:bold;',
                    xtype: 'textareafield',
                    emptyText: 'Need some text to describe what to put in this box \n Use N/A if not applicable to your discipline etc',
                  },
                  items: [{
                      fieldLabel: 'Senior Electrical Engineer\nApproval Comments',
                      value: wspf_10_cmf_eicomm,
                      name: 'vwspf_10_cmf_eicomm',
                      editable: (vUser === "DFRISWELL") ? true : false || (vUser === "R5") ? true : false,
                    },
                    {
                      fieldLabel: 'Senior Mechanical Engineer\nApproval Comments',
                      value: wspf_10_cmf_mechcomm,
                      name: 'vwspf_10_cmf_mechcomm',
                      editable: (vUser === "RKOCH") ? true : false || (vUser === "R5") ? true : false,
                    },
                    {
                      fieldLabel: 'Plant Operations Manager\nApproval Comments',
                      value: wspf_10_cmf_plantcomm,
                      name: 'vwspf_10_cmf_plantcomm',
                      editable: (vUser === "MLAGUITTON") ? true : false || (vUser === "R5") ? true : false,
                    },
                    {
                      fieldLabel: 'Safety\nApproval Comments',
                      value: wspf_10_cmf_safecomm,
                      name: 'vwspf_10_cmf_safecomm',
                      editable: (vUser === "TSCOTT") ? true : false || (vUser === "R5") ? true : false,
                    },
                    {
                      fieldLabel: 'Management Approval\nApproval Comments',
                      value: wspf_10_cmf_mancomm,
                      name: 'vwspf_10_cmf_mancomm',
                      editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false || (vUser === "JTAUVRY") ? true : false,
                    }
                  ]
                },
                {
                  xtype: 'fieldcontainer',
                  layout: 'vbox',
                  minWidth: 1150,
                  fieldLabel: '',
                  defaults: {
                    width: 500,
                    labelWidth: 200,
                    labelStyle: 'font-weight:bold;',
                    xtype: 'textfield'
                  },
                  items: [{
                      xtype: 'combo',
                      fieldLabel: 'Project Manager',
                      queryMode: 'local',
                      store: ['BLEE', 'BPAGE', 'CREID', 'CRODRIGUEZ', 'DCHENEY', 'DFRISWELL', 'DHOEDT', 'GMERCER', 'JREID', 'JTAUVRY', 'KHARRIS', 'LBURCHER', 'LWATKINS', 'MLAGUITTON', 'MLANE', 'PRAYNER', 'RKOCH', 'SBAHUTH', 'SIVANOVIC', 'SSLATTERY'],
                      autoSelect: true,
                      forceSelection: true,
                      value: wspf_10_cmf_owner,
                      name: 'vwspf_10_cmf_owner',
                      editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false || (vUser === "JTAUVRY") ? true : false,
                    },
                    {
                      xtype: 'numberfield',
                      width: 350,
                      fieldLabel: 'Approved $ for Concept Phase\n/Engineering Investigation',
                      value: wspf_10_cmf_invappcst,
                      name: 'vwspf_10_cmf_invappcst',
                      editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false || (vUser === "JTAUVRY") ? true : false,
                    },
                    {
                      xtype: 'combo',
                      queryMode: 'local',
                      store: ['Senior Electrical Engineer', 'Senior Mechanical Engineer'],
                      autoSelect: true,
                      forceSelection: true,
                      fieldLabel: 'Assigned Engineering Authority',
                      value: wspf_10_cmf_engauth,
                      name: 'vwspf_10_cmf_engauth',
                      editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false || (vUser === "JTAUVRY") ? true : false,
                    },
                    {
                      fieldLabel: 'Assigned External Engineering Review',
                      emptyText: 'If Required',
                      value: wspf_10_cmf_extengreview,
                      name: 'vwspf_10_cmf_extengreview',
                      editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false || (vUser === "JTAUVRY") ? true : false,
                    },
                    {
                      fieldLabel: 'Assigned Customer Representative',
                      emptyText: '(Aquasure/ State/ TDJV, etc.)',
                      value: wspf_10_cmf_custrep,
                      name: 'vwspf_10_cmf_custrep',
                      editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false || (vUser === "JTAUVRY") ? true : false,
                    },
                    {
                      xtype: 'combo',
                      fieldLabel: 'Select Route',
                      name: 'vwspf_10_cmf_chflow',
                      value: wspf_10_cmf_chflow,
                      queryMode: 'local',
                      store: ['1. Start engineering investigation', '2. Proceed to Concept', '3. Proceed to implementation (Perm. Mod.)', '4. Proceed to implementation (Temp. Mod.)', '5. Cancel'],
                      autoSelect: true,
                      forceSelection: true,
                      readOnly: !((vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false),
                    }
                  ],
                }
              ],
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                if (vFlag == false) {
                  win.close()
                }
                vFormPanel.setFldValue('wspf_10_cmf_eicomm', values.vwspf_10_cmf_eicomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_mechcomm', values.vwspf_10_cmf_mechcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_plantcomm', values.vwspf_10_cmf_plantcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_safecomm', values.vwspf_10_cmf_safecomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_mancomm', values.vwspf_10_cmf_mancomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_owner', values.vwspf_10_cmf_owner, true),
                  vFormPanel.setFldValue('wspf_10_cmf_invappcst', values.vwspf_10_cmf_invappcst, true),
                  vFormPanel.setFldValue('wspf_10_cmf_engauth', values.vwspf_10_cmf_engauth, true),
                  vFormPanel.setFldValue('wspf_10_cmf_extengreview', values.vwspf_10_cmf_extengreview, true),
                  vFormPanel.setFldValue('wspf_10_cmf_custrep', values.vwspf_10_cmf_custrep, true),
                  vFormPanel.setFldValue('wspf_10_cmf_chflow', values.vwspf_10_cmf_chflow, true);
                win.close();
              }
            }]
          }).show();
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_concdet]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vOwner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            vUser = gAppData.installParams.user,
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_evtstatus'),
            vFlag = !((((vUser === vOwner) ? true : false) && ((vStatus === 'Concept')) ? true : false) || ((vUser === 'R5') ? true : false)),
            wspf_10_cmf_conoverview = vFormPanel.getFldValue('wspf_10_cmf_conoverview'),
            wspf_10_cmf_conalt1 = vFormPanel.getFldValue('wspf_10_cmf_conalt1'),
            wspf_10_cmf_conalt2 = vFormPanel.getFldValue('wspf_10_cmf_conalt2'),
            wspf_10_cmf_condoc = vFormPanel.getFldValue('wspf_10_cmf_condoc'),
            wspf_10_cmf_condocupdate = vFormPanel.getFldValue('wspf_10_cmf_condocupdate'),
            wspf_10_cmf_condeliverables = vFormPanel.getFldValue('wspf_10_cmf_condeliverables'),
            wspf_10_cmf_conestlabour = vFormPanel.getFldValue('wspf_10_cmf_conestlabour'),
            wspf_10_cmf_conestmaterials = vFormPanel.getFldValue('wspf_10_cmf_conestmaterials'),
            wspf_10_cmf_conestother = vFormPanel.getFldValue('wspf_10_cmf_conestother'),
            wspf_10_cmf_conesttotal = vFormPanel.getFldValue('wspf_10_cmf_conesttotal'),
            wspf_10_cmf_desestlabour = vFormPanel.getFldValue('wspf_10_cmf_desestlabour'),
            wspf_10_cmf_desestmaterials = vFormPanel.getFldValue('wspf_10_cmf_desestmaterials'),
            wspf_10_cmf_desestother = vFormPanel.getFldValue('wspf_10_cmf_desestother'),
            wspf_10_cmf_desesttotal = vFormPanel.getFldValue('wspf_10_cmf_desesttotal');
          EAM.Utils.debugMessage(vFlag);
          EAM.Utils.debugMessage(gAppData.installParams.user);

          var condet = Ext.create('Ext.window.Window', {
            title: 'Concept Design Details',
            modal: true,
            autoShow: true,
            flex: 1,
            height: 800,
            scrollable: 'true',
            width: 1200,
            maximizable: true,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            bodyPadding: 10,
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                xtype: 'fieldcontainer',
                width: 1150,
                layout: 'vbox',
                fieldLabel: '',
                defaults: {
                  height: 120,
                  width: 1150,
                  labelWidth: 200,
                  flex: 1,
                  labelStyle: 'font-weight:bold;',
                  xtype: 'textareafield',
                },
                items: [{
                    fieldLabel: 'Final concept overview',
                    emptyText: '(Brief overview of concept design – it is noted that most information will be in the actual concept design which is accessible in Paradigm)',
                    value: wspf_10_cmf_conoverview,
                    name: 'vwspf_10_cmf_conoverview'
                  },
                  {
                    fieldLabel: 'Alternative 1 and reason for rejection ',
                    emptyText: '(If there is an alternative what is it and why has this alternative not been recommended for implementation)',
                    value: wspf_10_cmf_conalt1,
                    name: 'vwspf_10_cmf_conalt1'
                  },
                  {
                    fieldLabel: 'Alternative 2 and reason for rejection',
                    emptyText: '(If there is an alternative what is it and why has this alternative not been recommended for implementation)',
                    value: wspf_10_cmf_conalt2,
                    name: 'vwspf_10_cmf_conalt2'
                  },
                  {
                    fieldLabel: 'Concept documentation in Paradigm',
                    emptyText: '(Project manager saves all concept design documents to Paradigm with the project number at the start of the name, and adds list here. Cannot proceed to Detail Design unless documentation has been updated to Paradigm)',
                    value: wspf_10_cmf_condoc,
                    name: 'vwspf_10_cmf_condoc'
                  },
                  {
                    fieldLabel: 'Documentation requiring updating during detail phase',
                    value: wspf_10_cmf_condocupdate,
                    emptyText: '(Identify all Drawings, manuals, ops procedures, spares, etc. which need to be updated)',
                    name: 'vwspf_10_cmf_condocupdate'
                  },
                  {
                    fieldLabel: 'Agreed deliverables',
                    emptyText: '(List of deliverable outcomes for the project agreed between Project Manager, Assigned Customer and Assigned Engineering Authority)',
                    value: wspf_10_cmf_condeliverables,
                    name: 'vwspf_10_cmf_condeliverables'
                  },
                  {
                    xtype: 'fieldcontainer',
                    width: 1150,
                    height: 40,
                    fieldLabel: 'Initial Project cost for budgeting',
                    labelStyle: 'font-weight:bold;',
                    labelWidth: 200,
                    border: 3,
                    style: {
                      borderColor: '#E9E9E9',
                      borderStyle: 'solid'
                    },
                    layout: {
                      type: 'hbox',
                      align: 'stretch',
                    },
                    defaults: {
                      height: 40,
                      xtype: 'numberfield',
                      labelStyle: 'font-weight:bold;',
                      labelAlign: 'right',
                      emptyText: '(+/- 30%)',
                      flex: 1,
                      padding: 10,
                      width: 50,
                      labelWidth: 70,
                    },
                    items: [{
                        fieldLabel: 'Labour $',
                        value: wspf_10_cmf_conestlabour,
                        name: 'vwspf_10_cmf_conestlabour'
                      },
                      {
                        fieldLabel: 'Material $',
                        value: wspf_10_cmf_conestmaterials,
                        name: 'vwspf_10_cmf_conestmaterials'
                      },
                      {
                        fieldLabel: 'Other $',
                        value: wspf_10_cmf_conestother,
                        name: 'vwspf_10_cmf_conestother'
                      },
                      {
                        fieldLabel: 'Total $',
                        value: wspf_10_cmf_conesttotal,
                        name: 'vwspf_10_cmf_conesttotal'
                      }
                    ]
                  },
                  {
                    xtype: 'fieldcontainer',
                    width: 1150,
                    height: 40,
                    fieldLabel: 'Costs required for Detailed design phase',
                    labelStyle: 'font-weight:bold;',
                    labelWidth: 200,
                    border: 3,
                    style: {
                      borderColor: '#E9E9E9',
                      borderStyle: 'solid'
                    },
                    layout: {
                      type: 'hbox',
                      align: 'stretch',
                    },
                    defaults: {
                      height: 40,
                      xtype: 'numberfield',
                      labelStyle: 'font-weight:bold;',
                      labelAlign: 'right',
                      flex: 1,
                      padding: 10,
                      width: 50,
                      labelWidth: 70,
                    },
                    items: [{
                        fieldLabel: 'Labour $',
                        value: wspf_10_cmf_desestlabour,
                        name: 'vwspf_10_cmf_desestlabour'
                      },
                      {
                        fieldLabel: 'Material $',
                        value: wspf_10_cmf_desestmaterials,
                        name: 'vwspf_10_cmf_desestmaterials'
                      },
                      {
                        fieldLabel: 'Other $',
                        value: wspf_10_cmf_desestother,
                        name: 'vwspf_10_cmf_desestother'
                      },
                      {
                        fieldLabel: 'Total $',
                        value: wspf_10_cmf_desesttotal,
                        name: 'vwspf_10_cmf_desesttotal'
                      },
                    ]
                  },
                ]
              }],
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                if (vFlag == false) {
                  win.close()
                }
                vFormPanel.setFldValue('wspf_10_cmf_conoverview', values.vwspf_10_cmf_conoverview, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conalt1', values.vwspf_10_cmf_conalt1, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conalt2', values.vwspf_10_cmf_conalt2, true),
                  vFormPanel.setFldValue('wspf_10_cmf_condoc', values.vwspf_10_cmf_condoc, true),
                  vFormPanel.setFldValue('wspf_10_cmf_condocupdate', values.vwspf_10_cmf_condocupdate, true),
                  vFormPanel.setFldValue('wspf_10_cmf_condeliverables', values.vwspf_10_cmf_condeliverables, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conestlabour', values.vwspf_10_cmf_conestlabour, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conestmaterials', values.vwspf_10_cmf_conestmaterials, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conestother', values.vwspf_10_cmf_conestother, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conesttotal', values.vwspf_10_cmf_conesttotal, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desestlabour', values.vwspf_10_cmf_desestlabour, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desestmaterials', values.vwspf_10_cmf_desestmaterials, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desestother', values.vwspf_10_cmf_desestother, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desesttotal', values.vwspf_10_cmf_desesttotal, true);
                win.close();
              }
            }]
          }).show();
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_concappr]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vUser = gAppData.installParams.user,
            vOwner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_status'),
            vFlag = (vStatus == 'Concept Review (3 Pillars)') ? false : true || (vStatus == 'Concept Approval (Manager)') ? false : true, // (vStatus === "Change Request") ? false : true,
            wspf_10_cmf_conengappr = vFormPanel.getFldValue('wspf_10_cmf_conengappr'),
            wspf_10_cmf_conseicomm = vFormPanel.getFldValue('wspf_10_cmf_conseicomm'),
            wspf_10_cmf_conmechcomm = vFormPanel.getFldValue('wspf_10_cmf_conmechcomm'),
            wspf_10_cmf_conplantcomm = vFormPanel.getFldValue('wspf_10_cmf_conplantcomm'),
            wspf_10_cmf_concustagree = vFormPanel.getFldValue('wspf_10_cmf_concustagree'),
            wspf_10_cmf_conmancomm = vFormPanel.getFldValue('wspf_10_cmf_conmancomm'),
            wspf_10_cmf_descheck = vFormPanel.getForm().findField("wspf_10_cmf_descheck").getValue(),
            wspf_10_cmf_inbudget = vFormPanel.getForm().findField("wspf_10_cmf_inbudget").getValue(),
            wspf_10_cmf_desaddcst = vFormPanel.getFldValue('wspf_10_cmf_desaddcst'),
            wspf_10_cmf_budalloc = vFormPanel.getFldValue('wspf_10_cmf_budalloc'),
            wspf_10_cmf_chflow = vFormPanel.getFldValue('wspf_10_cmf_chflow');
          var condet = Ext.create('Ext.window.Window', {
            title: 'Concept Design Approval',
            modal: true,
            autoShow: true,
            flex: 1,
            height: 800,
            scrollable: 'true',
            width: 1200,
            maximizable: true,
            bodyPadding: 10,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                xtype: 'fieldcontainer',
                width: 1150,
                layout: 'vbox',
                fieldLabel: '',
                defaults: {
                  height: 120,
                  width: 1150,
                  labelWidth: 200,
                  flex: 1,
                  labelStyle: 'font-weight:bold;',
                  xtype: 'textareafield'
                },
                items: [{
                    fieldLabel: 'Assigned Engineering approval (external or 3 pillars) ',
                    emptyText: '(Certifies that the Concept design is saved to Paradigm and to suitable engineering standard)',
                    value: wspf_10_cmf_conengappr,
                    name: 'vwspf_10_cmf_conengappr',
                    editable: (vUser === vOwner) ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Senior Electrical Engineer\nApproval Comments',
                    value: wspf_10_cmf_conseicomm,
                    name: 'vwspf_10_cmf_conseicomm',
                    editable: (vUser === "DFRISWELL") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Senior Mechanical Engineer\nApproval Comments',
                    value: wspf_10_cmf_conmechcomm,
                    name: 'vwspf_10_cmf_conmechcomm',
                    editable: (vUser === "RKOCH") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Plant Operations Manager\nApproval Comments',
                    value: wspf_10_cmf_conplantcomm,
                    name: 'vwspf_10_cmf_conplantcomm',
                    editable: (vUser === "MLAGUITTON") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Assigned Customer agreement',
                    emptyText: '(Certifies that the Concept design is as per the customer requirements and that the agreed deliverables will achieve the desired outcomes)',
                    value: wspf_10_cmf_concustagree,
                    name: 'vwspf_10_cmf_concustagree',
                    editable: (vUser === vOwner) ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Asset Manager Approval',
                    emptyText: '(Approves 1.Proceeding to detail design phase. 2. Shortcut route straight to implementation. 3. Additional $ for design. 4. Project budget)',
                    value: wspf_10_cmf_conmancomm,
                    name: 'vwspf_10_cmf_conmancomm',
                    editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    xtype: 'fieldcontainer',
                    width: 1150,
                    layout: 'hbox',
                    fieldLabel: '',
                    defaults: {
                      width: 250,
                      labelWidth: 120,
                      flex: 1,
                      labelStyle: 'font-weight:bold;',
                      xtype: 'numberfield'
                    },
                    items: [{
                        xtype: 'checkbox',
                        labelAlign: 'right',
                        width: 120,
                        fieldLabel: 'Is Detail Design Required',
                        value: wspf_10_cmf_descheck,
                        name: 'vwspf_10_cmf_descheck',
                        editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false,
                      },
                      {
                        fieldLabel: 'Additional $ for Detail Design',
                        value: wspf_10_cmf_desaddcst,
                        name: 'vwspf_10_cmf_desaddcst',
                        editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false,
                      },
                      {
                        xtype: 'checkbox',
                        labelAlign: 'right',
                        width: 120,
                        fieldLabel: 'Is the project included in the budget',
                        value: wspf_10_cmf_inbudget,
                        name: 'vwspf_10_cmf_inbudget',
                        editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false,
                      },
                      {
                        fieldLabel: 'Budget allocation $ (entered by Asset Manager)',
                        value: wspf_10_cmf_budalloc,
                        name: 'vwspf_10_cmf_budalloc',
                        editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false,
                      },

                    ]
                  }, {
                    xtype: 'combo',
                    fieldLabel: 'Select Route',
                    name: 'vwspf_10_cmf_chflow',
                    value: wspf_10_cmf_chflow,
                    queryMode: 'local',
                    store: ['1. Proceed to Detail Design', '2. Proceed to implementation (Perm. Mod.)', '3. Proceed to implementation (Temp. Mod.)', '4. Cancel'],
                    autoSelect: true,
                    height: 40,
                    forceSelection: true,
                    readOnly: !((vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false),
                  }
                ]
              }, ]
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                if (vFlag == true) {
                  win.close();
                }
                vFormPanel.setFldValue('wspf_10_cmf_conengappr', values.vwspf_10_cmf_conengappr, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conseicomm', values.vwspf_10_cmf_conseicomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conmechcomm', values.vwspf_10_cmf_conmechcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conplantcomm', values.vwspf_10_cmf_conplantcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_concustagree', values.vwspf_10_cmf_concustagree, true),
                  vFormPanel.setFldValue('wspf_10_cmf_conmancomm', values.vwspf_10_cmf_conmancomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desaddcst', values.vwspf_10_cmf_desaddcst, true),
                  vFormPanel.getForm().findField("wspf_10_cmf_inbudget").setValue(form.getForm().findField("vwspf_10_cmf_inbudget").getValue()),
                  vFormPanel.getForm().findField("wspf_10_cmf_descheck").setValue(form.getForm().findField("vwspf_10_cmf_descheck").getValue()),
                  vFormPanel.setFldValue('wspf_10_cmf_budalloc', values.vwspf_10_cmf_budalloc, true),
                  vFormPanel.setFldValue('wspf_10_cmf_chflow', values.vwspf_10_cmf_chflow, true);
                win.close();
              }
            }]
          }).show();
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_detaildesign]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vUser = gAppData.installParams.user,
            vOwner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_status'),
            vFlag = !((((vUser === vOwner) ? true : false) && ((vStatus === 'Detail Design')) ? true : false) || ((vUser === 'R5') ? true : false)),
            wspf_10_cmf_projnum = vFormPanel.getFldValue('wspf_10_cmf_projnum'),
            wspf_10_cmf_desover = vFormPanel.getFldValue('wspf_10_cmf_desover'),
            wspf_10_cmf_desdocpara = vFormPanel.getFldValue('wspf_10_cmf_desdocpara'),
            wspf_10_cmf_desdoc = vFormPanel.getFldValue('wspf_10_cmf_desdoc'),
            wspf_10_cmf_desdocdraw = vFormPanel.getFldValue('wspf_10_cmf_desdocdraw'),
            wspf_10_cmf_projestlabour = vFormPanel.getFldValue('wspf_10_cmf_projestlabour'),
            wspf_10_cmf_projestmaterials = vFormPanel.getFldValue('wspf_10_cmf_projestmaterials'),
            wspf_10_cmf_projestother = vFormPanel.getFldValue('wspf_10_cmf_projestother'),
            wspf_10_cmf_projesttotal = vFormPanel.getFldValue('wspf_10_cmf_projesttotal'),
            wspf_10_cmf_projdescost = vFormPanel.getFldValue('wspf_10_cmf_projdescost');
          var detdes = Ext.create('Ext.window.Window', {
            title: 'Detail Design',
            modal: true,
            autoShow: true,
            flex: 1,
            height: 800,
            scrollable: 'true',
            width: 1200,
            maximizable: true,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            bodyPadding: 10,
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                xtype: 'fieldcontainer',
                minWidth: 1150,
                layout: 'vbox',
                fieldLabel: '',
                defaults: {
                  height: 120,
                  width: 1150,
                  labelWidth: 200,
                  flex: 1,
                  labelStyle: 'font-weight:bold;',
                  xtype: 'textareafield'
                },
                items: [{
                    fieldLabel: 'Project Number',
                    height: 40,
                    emptyText: '(A CH number has to be generated only if it is TDJV works)',
                    value: wspf_10_cmf_projnum,
                    name: 'vwspf_10_cmf_projnum'
                  },
                  {
                    fieldLabel: 'Detail design overview',
                    value: wspf_10_cmf_desover,
                    name: 'vwspf_10_cmf_desover'
                  },
                  {
                    fieldLabel: 'Detailed design documentation in Paradigm',
                    value: wspf_10_cmf_desdocpara,
                    emptyText: '(Project manager saves all Detail design documents to Paradigm with the project number at the start of the name, and adds list here. Cannot proceed to Implementation unless documentation has been updated to Paradigm)',
                    name: 'vwspf_10_cmf_desdocpara'
                  },
                  {
                    fieldLabel: 'Documentation updated with detail design ',
                    emptyText: '(Physical update record of Manuals, ops procedures, spares, etc.) ',
                    value: wspf_10_cmf_desdoc,
                    name: 'vwspf_10_cmf_desdoc'
                  },
                  {
                    fieldLabel: 'Drawings updated',
                    emptyText: '(Physical update record of Drawings/ PID’s/ Additional drawings saved to Paradigm)',
                    value: wspf_10_cmf_desdocdraw,
                    name: 'vwspf_10_cmf_desdocdraw'
                  },
                  {
                    xtype: 'fieldcontainer',
                    height: 40,
                    layout: 'hbox',
                    labelwidth: 200,
                    labelAlign: 'right',
                    fieldLabel: 'Project cost approval',
                    defaults: {
                      width: 50,
                      labelWidth: 70,
                      labelAlign: 'right',
                      flex: 1,
                      emptyText: '(+/- 5%)',
                      labelStyle: 'font-weight:bold;',
                      xtype: 'numberfield'
                    },
                    items: [{
                        fieldLabel: 'Labour $',
                        value: wspf_10_cmf_projestlabour,
                        name: 'vwspf_10_cmf_projestlabour'
                      },
                      {
                        fieldLabel: 'Material $',
                        value: wspf_10_cmf_projestmaterials,
                        name: 'vwspf_10_cmf_projestmaterials'
                      },
                      {
                        fieldLabel: 'Other $',
                        value: wspf_10_cmf_projestother,
                        name: 'vwspf_10_cmf_projestother'
                      },
                      {
                        fieldLabel: 'Total $',
                        value: wspf_10_cmf_projesttotal,
                        name: 'vwspf_10_cmf_projesttotal'
                      },
                    ]
                  },
                  {
                    xtype: 'fieldcontainer',
                    height: 40,
                    width: 500,
                    layout: 'hbox',
                    fieldLabel: '',
                    defaults: {
                      width: 270,
                      labelWidth: 200,
                      labelAlign: 'right',
                      flex: 1,
                      labelStyle: 'font-weight:bold;',
                      xtype: 'numberfield'
                    },
                    items: [{
                      fieldLabel: 'Design costs',
                      emptyText: '(Concept + Detail Actual)',
                      value: wspf_10_cmf_projdescost,
                      name: 'vwspf_10_cmf_projdescost'
                    }, ]
                  }
                ]
              }, ]
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                if (vFlag == true) {
                  win.close()
                }
                vFormPanel.setFldValue('wspf_10_cmf_projnum', values.vwspf_10_cmf_projnum, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desover', values.vwspf_10_cmf_desover, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desdocpara', values.vwspf_10_cmf_desdocpara, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desdoc', values.vwspf_10_cmf_desdoc, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desdocdraw', values.vwspf_10_cmf_desdocdraw, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projestlabour', values.vwspf_10_cmf_projestlabour, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projestmaterials', values.vwspf_10_cmf_projestmaterials, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projestother', values.vwspf_10_cmf_projestother, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projesttotal', values.vwspf_10_cmf_projesttotal, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projdescost', values.vwspf_10_cmf_projdescost, true);
                win.close();
              }
            }]
          }).show();
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_desappr]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vUser = gAppData.installParams.user,
            vOwner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_status'),
            vFlag = false, // (vStatus === "Change Request") ? false : true,
            wspf_10_cmf_desengappr = vFormPanel.getFldValue('wspf_10_cmf_desengappr'),
            wspf_10_cmf_desseicomm = vFormPanel.getFldValue('wspf_10_cmf_desseicomm'),
            wspf_10_cmf_desmechcomm = vFormPanel.getFldValue('wspf_10_cmf_desmechcomm'),
            wspf_10_cmf_desplantcomm = vFormPanel.getFldValue('wspf_10_cmf_desplantcomm'),
            wspf_10_cmf_descustagree = vFormPanel.getFldValue('wspf_10_cmf_descustagree'),
            wspf_10_cmf_desamcomm = vFormPanel.getFldValue('wspf_10_cmf_desamcomm'),
            wspf_10_cmf_desopscomm = vFormPanel.getFldValue('wspf_10_cmf_desopscomm'),
            wspf_10_cmf_chflow = vFormPanel.getFldValue('wspf_10_cmf_chflow');
          var desappr = Ext.create('Ext.window.Window', {
            title: 'Detail Design Approval',
            modal: true,
            autoShow: true,
            flex: 1,
            height: 800,
            scrollable: 'true',
            width: 1200,
            maximizable: true,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            bodyPadding: 10,
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                xtype: 'fieldcontainer',
                minWidth: 1150,
                layout: 'vbox',
                fieldLabel: '',
                defaults: {
                  height: 120,
                  width: 1150,
                  labelWidth: 200,
                  flex: 1,
                  labelStyle: 'font-weight:bold;',
                  xtype: 'textareafield'
                },
                items: [{
                    fieldLabel: 'Assigned Engineering approval (external or 3 pillars) ',
                    emptyText: '(Certifies that the Detail design is saved to Paradigm and to suitable engineering standard)',
                    value: wspf_10_cmf_desengappr,
                    name: 'vwspf_10_cmf_desengappr',
                    editable: (vUser === vOwner) ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Senior Electrical Engineer',
                    value: wspf_10_cmf_desseicomm,
                    name: 'vwspf_10_cmf_desseicomm',
                    editable: (vUser === "DFRISWELL") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Senior Mechanical Engineer',
                    value: wspf_10_cmf_desmechcomm,
                    name: 'vwspf_10_cmf_desmechcomm',
                    editable: (vUser === "RKOCH") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Plant Operations Manager',
                    value: wspf_10_cmf_desplantcomm,
                    name: 'vwspf_10_cmf_desplantcomm',
                    editable: (vUser === "MLAGUITTON") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Assigned Customer agreement',
                    emptyText: '(Certifies that the Concept design is as per the customer requirements and that the agreed deliverables will achieve the desired outcomes)',
                    value: wspf_10_cmf_descustagree,
                    name: 'vwspf_10_cmf_descustagree',
                    editable: (vUser === vOwner) ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Operations Manager (If required)',
                    value: wspf_10_cmf_desopscomm,
                    name: 'vwspf_10_cmf_desopscomm',
                    editable: (vUser === "JTAUVRY") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Asset Manager Approval to Proceed to Implementation',
                    value: wspf_10_cmf_desamcomm,
                    emptyText: '(Authorises expenditure and final approval to proceed to implementation)',
                    name: 'vwspf_10_cmf_desamcomm',
                    editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    xtype: 'combo',
                    fieldLabel: 'Select Route',
                    name: 'vwspf_10_cmf_chflow',
                    value: wspf_10_cmf_chflow,
                    queryMode: 'local',
                    height: 40,
                    store: ['1. Proceed to implementation (Perm. Mod.)', '2. Proceed to implementation (Temp. Mod.)', '3. Cancel'],
                    autoSelect: true,
                    forceSelection: true,
                    readOnly: !((vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false),
                  }
                ]
              }, ]
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                if (vFlag == true) {
                  win.close()
                };
                vFormPanel.setFldValue('wspf_10_cmf_desengappr', values.vwspf_10_cmf_desengappr, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desseicomm', values.vwspf_10_cmf_desseicomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desmechcomm', values.vwspf_10_cmf_desmechcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desplantcomm', values.vwspf_10_cmf_desplantcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_descustagree', values.vwspf_10_cmf_descustagree, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desamcomm', values.vwspf_10_cmf_desamcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_desopscomm', values.vwspf_10_cmf_desopscomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_chflow', values.vwspf_10_cmf_chflow, true);
                win.close();
              }
            }]
          }).show();
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_impdetail]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vUser = gAppData.installParams.user,
            vOwner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_status'),
            vFlag = !((((vUser === vOwner) ? true : false) && ((vStatus === 'Implementation')) ? true : false) || ((vUser === 'R5') ? true : false)),
            wspf_10_cmf_impchanges = vFormPanel.getFldValue('wspf_10_cmf_impchanges'),
            wspf_10_cmf_impdocpara = vFormPanel.getFldValue('wspf_10_cmf_impdocpara'),
            wspf_10_cmf_impdoc = vFormPanel.getFldValue('wspf_10_cmf_impdoc'),
            wspf_10_cmf_impdraw = vFormPanel.getFldValue('wspf_10_cmf_impdraw'),
            wspf_10_cmf_impoutstand = vFormPanel.getFldValue('wspf_10_cmf_impoutstand'),
            wspf_10_cmf_projlabour = vFormPanel.getFldValue('wspf_10_cmf_projlabour'),
            wspf_10_cmf_projmaterials = vFormPanel.getFldValue('wspf_10_cmf_projmaterials'),
            wspf_10_cmf_projother = vFormPanel.getFldValue('wspf_10_cmf_projother'),
            wspf_10_cmf_projtotal = vFormPanel.getFldValue('wspf_10_cmf_projtotal'),
            wspf_10_cmf_projdescostfinal = vFormPanel.getFldValue('wspf_10_cmf_projdescostfinal');
          var impdet = Ext.create('Ext.window.Window', {
            title: 'Implementation Details',
            modal: true,
            autoShow: true,
            flex: 1,
            height: 800,
            scrollable: 'true',
            width: 1200,
            maximizable: true,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            bodyPadding: 10,
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                xtype: 'fieldcontainer',
                minWidth: 1150,
                layout: 'vbox',
                fieldLabel: '',
                defaults: {
                  height: 120,
                  width: 1150,
                  labelWidth: 200,
                  flex: 1,
                  labelStyle: 'font-weight:bold;',
                  xtype: 'textareafield'
                },
                items: [{
                    fieldLabel: 'Changes made to approved detail design',
                    value: wspf_10_cmf_impchanges,
                    name: 'vwspf_10_cmf_impchanges'
                  },
                  {
                    fieldLabel: 'As built documentation in Paradigm',
                    emptyText: '(Project manager saves all changes to design documents and as built records to Paradigm with the project number at the start of the name, and adds list here. Note yellow folders no longer required.)',
                    value: wspf_10_cmf_impdocpara,
                    name: 'vwspf_10_cmf_impdocpara'
                  },
                  {
                    fieldLabel: 'Documentation updated with as built information',
                    value: wspf_10_cmf_impdoc,
                    emptyText: '(Physical update record of Manuals, ops procedures, spares, etc.)',
                    name: 'vwspf_10_cmf_impdoc'
                  },
                  {
                    fieldLabel: 'Drawings updated',
                    value: wspf_10_cmf_impdraw,
                    emptyText: '(Physical update record of drawings)',
                    name: 'vwspf_10_cmf_impdraw'
                  },
                  {
                    fieldLabel: 'Outstanding issues',
                    value: wspf_10_cmf_impoutstand,
                    emptyText: '(Link to Paradigm document)',
                    name: 'vwspf_10_cmf_impoutstand'
                  },
                  {
                    xtype: 'fieldcontainer',
                    height: 40,
                    layout: 'hbox',
                    labelwidth: 150,
                    fieldLabel: 'Total Project Costs',
                    defaults: {
                      width: 50,
                      labelWidth: 70,
                      labelAlign: 'right',
                      flex: 1,
                      labelStyle: 'font-weight:bold;',
                      xtype: 'numberfield'
                    },
                    items: [{
                        fieldLabel: 'Labour $',
                        emptyText: '(Final)',
                        value: wspf_10_cmf_projlabour,
                        name: 'vwspf_10_cmf_projlabour'
                      },
                      {
                        fieldLabel: 'Material $',
                        emptyText: '(Final)',
                        value: wspf_10_cmf_projmaterials,
                        name: 'vwspf_10_cmf_projmaterials'
                      },
                      {
                        fieldLabel: 'Other $',
                        labelWidth: 50,
                        emptyText: '(Final)',
                        value: wspf_10_cmf_projother,
                        name: 'vwspf_10_cmf_projother'
                      },
                      {
                        fieldLabel: 'Total $',
                        labelWidth: 50,
                        emptyText: '(Final)',
                        value: wspf_10_cmf_projtotal,
                        name: 'vwspf_10_cmf_projtotal'
                      },
                      {
                        fieldLabel: 'Design costs',
                        labelWidth: 100,
                        emptyText: '(Final)',
                        value: wspf_10_cmf_projdescostfinal,
                        name: 'vwspf_10_cmf_projdescostfinal'
                      },
                    ]
                  }
                ]
              }, ]
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                if (vFlag == true) {
                  win.close()
                }
                vFormPanel.setFldValue('wspf_10_cmf_impchanges', values.vwspf_10_cmf_impchanges, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impdocpara', values.vwspf_10_cmf_impdocpara, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impdoc', values.vwspf_10_cmf_impdoc, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impdraw', values.vwspf_10_cmf_impdraw, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impoutstand', values.vwspf_10_cmf_impoutstand, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projlabour', values.vwspf_10_cmf_projlabour, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projmaterials', values.vwspf_10_cmf_projmaterials, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projother', values.vwspf_10_cmf_projother, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projtotal', values.vwspf_10_cmf_projtotal, true),
                  vFormPanel.setFldValue('wspf_10_cmf_projdescostfinal', values.vwspf_10_cmf_projdescostfinal, true);
                win.close();
              }
            }]
          }).show();
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=wspf_10_cmf_impappr]': {
        blur: function(field, lastValues) {
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vUser = gAppData.installParams.user,
            vOwner = vFormPanel.getFldValue('wspf_10_cmf_owner'),
            vStatus = vFormPanel.getFldValue('wspf_10_cmf_status'),
            vFlag = (vStatus === 'Implementation Sign Off') ? false : true, // (vStatus === "Change Request") ? false : true,
            wspf_10_cmf_impengappr = vFormPanel.getFldValue('wspf_10_cmf_impengappr'),
            wspf_10_cmf_impseicomm = vFormPanel.getFldValue('wspf_10_cmf_impseicomm'),
            wspf_10_cmf_impmechcomm = vFormPanel.getFldValue('wspf_10_cmf_impmechcomm'),
            wspf_10_cmf_impplantcomm = vFormPanel.getFldValue('wspf_10_cmf_impplantcomm'),
            wspf_10_cmf_impcustagree = vFormPanel.getFldValue('wspf_10_cmf_impcustagree'),
            wspf_10_cmf_impamcomm = vFormPanel.getFldValue('wspf_10_cmf_impamcomm'),
            wspf_10_cmf_impopscomm = vFormPanel.getFldValue('wspf_10_cmf_impopscomm'),
            wspf_10_cmf_impdoccontreview = vFormPanel.getFldValue('wspf_10_cmf_impdoccontreview'),
            wspf_10_cmf_impdirector = vFormPanel.getFldValue('wspf_10_cmf_impdirector');
          var impappr = Ext.create('Ext.window.Window', {
            title: 'Implementation Approval',
            modal: true,
            autoShow: true,
            flex: 1,
            height: 800,
            scrollable: 'true',
            width: 1200,
            maximizable: true,
            bodyStyle: 'background-color:#F0F0F0;padding: 10px',
            bodyPadding: 10,
            items: [{
              xtype: 'form',
              bodyStyle: 'background-color:#F0F0F0;padding: 10px',
              fieldDefaults: {
                readOnly: vFlag
              },
              items: [{
                xtype: 'fieldcontainer',
                minWidth: 1150,
                layout: 'vbox',
                fieldLabel: '',
                defaults: {
                  height: 120,
                  width: 1150,
                  labelWidth: 200,
                  flex: 1,
                  labelStyle: 'font-weight:bold;',
                  xtype: 'textareafield'
                },
                items: [{
                    fieldLabel: 'Assigned Engineering approval (external or 3 pillars) ',
                    emptyText: '(Certifies that the Detail design is saved to Paradigm and to suitable engineering standard)',
                    value: wspf_10_cmf_impengappr,
                    name: 'vwspf_10_cmf_impengappr',
                    editable: (vUser === vOwner) ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Senior Electrical Engineer',
                    value: wspf_10_cmf_impseicomm,
                    name: 'vwspf_10_cmf_impseicomm',
                    editable: (vUser === "DFRISWELL") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Senior Mechanical Engineer',
                    value: wspf_10_cmf_impmechcomm,
                    name: 'vwspf_10_cmf_impmechcomm',
                    editable: (vUser === "RKOCH") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Plant Operations Manager',
                    value: wspf_10_cmf_impplantcomm,
                    name: 'vwspf_10_cmf_impplantcomm',
                    editable: (vUser === "MLAGUITTON") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Doc. Controller Review',
                    value: wspf_10_cmf_impdoccontreview,
                    emptyText: '(Confirms all documentation saved to Paradigm and in the right locations)',
                    name: 'vwspf_10_cmf_impdoccontreview',
                    editable: (vUser === "ALAWSON") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Assigned Customer agreement',
                    emptyText: '(Accepts that the project has achieved the Agreed Deliverables.)',
                    value: wspf_10_cmf_impcustagree,
                    name: 'vwspf_10_cmf_impcustagree',
                    editable: (vUser === vOwner) ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Asset Manager Approval to Proceed to Implementation',
                    value: wspf_10_cmf_impamcomm,
                    emptyText: '((Final closeout acceptance)',
                    name: 'vwspf_10_cmf_impamcomm',
                    editable: (vUser === "SBAHUTH") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Operations Manager (If required)',
                    value: wspf_10_cmf_impopscomm,
                    name: 'vwspf_10_cmf_impopscomm',
                    editable: (vUser === "JTAUVRY") ? true : false || (vUser === "R5") ? true : false,
                  },
                  {
                    fieldLabel: 'Director',
                    value: wspf_10_cmf_impdirector,
                    emptyText: '(Final Site acceptance)',
                    name: 'vwspf_10_cmf_impdirector',
                    editable: (vUser === "GMERCER") ? true : false || (vUser === "R5") ? true : false,
                  },
                ]
              }, ]
            }],
            buttons: [{
              text: 'submit',
              formBind: true,
              handler: function(btn) {
                var win = btn.up('window'),
                  form = win.down('form'),
                  values = form.getValues();
                if (vFlag == true) {
                  win.close()
                }
                vFormPanel.setFldValue('wspf_10_cmf_impengappr', values.vwspf_10_cmf_impengappr, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impseicomm', values.vwspf_10_cmf_impseicomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impmechcomm', values.vwspf_10_cmf_impmechcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impplantcomm', values.vwspf_10_cmf_impplantcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impcustagree', values.vwspf_10_cmf_impcustagree, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impamcomm', values.vwspf_10_cmf_impamcomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impopscomm', values.vwspf_10_cmf_impopscomm, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impdoccontreview', values.vwspf_10_cmf_impdoccontreview, true),
                  vFormPanel.setFldValue('wspf_10_cmf_impdirector', values.vwspf_10_cmf_impdirector, true);
                win.close();
              }
            }]
          }).show();
        }
      },
    }
  }
});
