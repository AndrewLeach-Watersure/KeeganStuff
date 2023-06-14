Ext.define("EAM.custom.external_OSOCDE", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true]": {
        afterloaddata: function (field, lastValues) {
          EAM.Utils.debugMessage("afterloaddata");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vBdg = vFormPanel.getFldValue("udfchar01"),
            vUser = gAppData.installParams.user;
          if (vBdg) {
            var response = EAM.Ajax.request({
              url: "GRIDDATA",
              params: {
                GRID_NAME: "XU0006",
                REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                LOV_ALIAS_NAME_1: "bdg",
                LOV_ALIAS_VALUE_1: vBdg,
                LOV_ALIAS_TYPE_1: "",
              },
              async: false,
              method: "POST",
            });

            (vOwner =
              response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                .str_owner),
              (vAssetman =
                response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                  .str_assetman),
              (vStrategy =
                response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                  .str_code),
              (vDelegate =
                response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                  .str_delegate);

            EAM.Utils.debugMessage(vOwner);
            EAM.Utils.debugMessage(vAssetman);
            EAM.Utils.debugMessage(vStrategy);
            EAM.Utils.debugMessage(vDelegate);
            vFormPanel.setFldValue("udfchar02", vStrategy, false),
              vFormPanel.setFldValue("udfchar03", vOwner, false);

            if (vUser == vOwner || vUser == vAssetman || vUser == vDelegate) {
              EAM.Builder.setFieldState(
                {
                  servicelife: "optional",
                  servicelifeusage: "optional",
                  servicelifeusageuom: "optional",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          } else {
            vFormPanel.setFldValue("udfchar02", null, false),
              vFormPanel.setFldValue("udfchar03", null, false);
          }
        }, //
      },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=udfchar01]": {
        blur: function (field, lastValues) {
          EAM.Utils.debugMessage("blur");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vBdg = vFormPanel.getFldValue("udfchar01"),
            vUser = gAppData.installParams.user;
          if (vBdg) {
            var response = EAM.Ajax.request({
              url: "GRIDDATA",
              params: {
                GRID_NAME: "XU0006",
                REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                LOV_ALIAS_NAME_1: "bdg",
                LOV_ALIAS_VALUE_1: vBdg,
                LOV_ALIAS_TYPE_1: "",
              },
              async: false,
              method: "POST",
            });

            (vOwner =
              response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                .str_owner),
              (vAssetman =
                response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                  .str_assetman),
              (vStrategy =
                response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                  .str_code),
              (vDelegate =
                response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                  .str_delegate);

            EAM.Utils.debugMessage(vOwner);
            EAM.Utils.debugMessage(vAssetman);
            EAM.Utils.debugMessage(vStrategy);
            EAM.Utils.debugMessage(vDelegate);
            vFormPanel.setFldValue("udfchar02", vStrategy, false),
              vFormPanel.setFldValue("udfchar03", vOwner, false);

            if (vUser == vOwner || vUser == vAssetman || vUser == vDelegate) {
              EAM.Builder.setFieldState(
                {
                  servicelife: "optional",
                  servicelifeusage: "optional",
                  servicelifeusageuom: "optional",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          } else {
            vFormPanel.setFldValue("udfchar02", null, false),
              vFormPanel.setFldValue("udfchar03", null, false);
          }
        },
      },
    };
  },
});
