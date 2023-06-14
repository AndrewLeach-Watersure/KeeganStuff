Ext.define('EAM.custom.external_WSWREQ', {
  extend: 'EAM.custom.AbstractExtensibleFramework',
  getSelectors: function() {
    return {
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=description]': {
        blur: function(field, lastValues) {
          var vFormPanel = field.formPanel;
          EAM.Utils.debugMessage('Focus');
          vFormPanel.getForm().findField("udfchkbox01").setValue(false);
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=udfchar21]': {
        blur: function(field, lastValues) {
          EAM.Utils.debugMessage('udfchar21');
          var vFormPanel = field.formPanel,
            team = vFormPanel.getFldValue('udfchar21'),
            mrc = vFormPanel.getFldValue('department');

          if (team == 'EI' || team == 'MECH' || team == 'PROJ' || team == 'ENG') {
            mrc = 'ENG'
          } else if (team == 'PRO' || team == 'SITEOPS' || team == 'OPS' || team == 'PLANTOPS' || team == 'FAC') {
            mrc = 'OPS'
          } else {
            mrc = team
          }
          vFormPanel.setFldValue('department', mrc, false);
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=equipment]': {
        blur: function(field, lastValues) {
          EAM.Utils.debugMessage('equipment');
          var vFormPanel = field.formPanel,
            team = vFormPanel.getFldValue('udfchar21'),
            mrc = vFormPanel.getFldValue('department');

          if (team == 'EI' || team == 'MECH' || team == 'PROJ' || team == 'ENG') {
            mrc = 'ENG'
          } else if (team == 'PRO' || team == 'SITEOPS' || team == 'OPS' || team == 'PLANTOPS' || team == 'FAC') {
            mrc = 'OPS'
          } else {
            mrc = team
          }
          vFormPanel.setFldValue('department', mrc, false);
        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=priority]': {
        blur: function(field, lastValues) {
          EAM.Utils.debugMessage('priority');
          var vFormPanel = field.formPanel,
            vPri = vFormPanel.getFldValue('priority'),
            vDue = vFormPanel.getFldValue('udfdate02'),
            vCreated = vFormPanel.getFldValue('datecreated'),
            vStatus = vFormPanel.getFldValue('workorderstatus');
          if (vCreated == null) {
            vCreated = new Date()
          }
          EAM.Utils.debugMessage(vCreated);
          EAM.Utils.debugMessage(vDue);
          if (vPri == 1 && (vStatus == 'Q'|| vStatus == 'QUNF')) {
            document.getElementsByName('udfdate03')[0].value = Ext.Date.format(Ext.Date.add(new Date(), Ext.Date.DAY, 7), 'd/M/Y');
            document.getElementsByName('udfdate02')[0].value = Ext.Date.format(Ext.Date.add(new Date(), Ext.Date.DAY, 7), 'd/M/Y');
            vFormPanel.setFldValue('workordertype', 'CMPR', false);
            document.getElementsByName('udfchar24')[0].select();
          }
          if (vPri == 2 && (vStatus == 'Q'|| vStatus == 'QUNF')) {
            document.getElementsByName('udfdate03')[0].value = Ext.Date.format(Ext.Date.add(vCreated, Ext.Date.MONTH, 1), 'd/M/Y');
            document.getElementsByName('udfdate03')[0].select();
            document.getElementsByName('udfdate02')[0].value = Ext.Date.format(Ext.Date.add(vCreated, Ext.Date.MONTH, 1), 'd/M/Y');
            document.getElementsByName('udfdate02')[0].select();
            vFormPanel.setFldValue('workordertype', 'CMPR', false);
            document.getElementsByName('udfchar24')[0].select();
          }
          if (vPri == 3 && (vStatus == 'Q'|| vStatus == 'QUNF')) {
            document.getElementsByName('udfdate03')[0].value = Ext.Date.format(Ext.Date.add(vCreated, Ext.Date.MONTH, 3), 'd/M/Y');
            document.getElementsByName('udfdate03')[0].select();
            document.getElementsByName('udfdate02')[0].value = Ext.Date.format(Ext.Date.add(vCreated, Ext.Date.MONTH, 3), 'd/M/Y');
            document.getElementsByName('udfdate02')[0].select();
            vFormPanel.setFldValue('workordertype', 'CMPR', false);
            document.getElementsByName('udfchar24')[0].select();
          }
          if (vPri == 4 && (vStatus == 'Q'|| vStatus == 'QUNF')) {
            document.getElementsByName('udfdate03')[0].value = Ext.Date.format(Ext.Date.add(vCreated, Ext.Date.MONTH, 12), 'd/M/Y');
            document.getElementsByName('udfdate03')[0].select();
            document.getElementsByName('udfdate02')[0].value = Ext.Date.format(Ext.Date.add(vCreated, Ext.Date.MONTH, 12), 'd/M/Y');
            document.getElementsByName('udfdate02')[0].select();
            vFormPanel.setFldValue('workordertype', 'CMPR', false);
            document.getElementsByName('udfchar24')[0].select();
          }
          if (vPri == 'BD') {
            document.getElementsByName('udfdate03')[0].value = Ext.Date.format(Ext.Date.add(new Date(), Ext.Date.DAY, 0), 'd/M/Y');
            document.getElementsByName('udfdate03')[0].select();
            document.getElementsByName('udfdate02')[0].value = Ext.Date.format(Ext.Date.add(new Date(), Ext.Date.DAY, 0), 'd/M/Y');
            document.getElementsByName('udfdate02')[0].select();
            vFormPanel.setFldValue('workordertype', 'CMBD', false);
            document.getElementsByName('udfchar24')[0].select();
          }

        }
      },
      '[extensibleFramework] [tabName=HDR][isTabView=true] [name=udfchkbox01]': {
    focus: function(field, lastValues) {
      var vFormPanel = field.formPanel,
        vEquipmunk = vFormPanel.getForm().findField('equipment').getValue();
        vCheck = vFormPanel.getForm().findField('udfchkbox01').getValue();
      EAM.Utils.debugMessage(vEquipmunk);
if (vCheck == false) {

        var response = EAM.Ajax.request({
        url: 'GRIDDATA',
        params: {
          GRID_NAME: 'XU0004',
          REQUEST_TYPE: 'LIST.HEAD_DATA.STORED',
          LOV_ALIAS_NAME_1: 'equipmunk',
          LOV_ALIAS_VALUE_1: vEquipmunk,
          LOV_ALIAS_TYPE_1: ''
        },
        async: false,
        method: 'POST'
      });


if (vEquipmunk)
  {
  vNewEquipmunk = response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0].obj_udfchar28,
  vNewDescription = response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0].repgetdesc;
  EAM.Utils.debugMessage(vNewEquipmunk);
  if(!vNewEquipmunk) { vNewEquipmunk = vEquipmunk, vNewDescription = 'No Pipe Reference Found' };
  vFormPanel.setFldValue('equipment',vNewEquipmunk, false),
  vFormPanel.setFldValue('equipmentdesc',vNewDescription , false);

  };
      };
  vFormPanel.getForm().findField("udfchkbox01").setValue(false);
  vFormPanel.getForm().findField('description').select;
              }
        },

	}
  }
});
