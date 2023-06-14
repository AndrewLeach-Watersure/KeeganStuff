Ext.define("EAM.custom.external_UUSTRA", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true]": {
        afterloaddata: function (field, lastValues) {
          EAM.Utils.debugMessage("afterloaddata");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vStr = vFormPanel.getFldValue("wspf_10_str_code"),
            vUser = gAppData.installParams.user;
          EAM.Utils.debugMessage(vStr);
          if (vStr) {
            var response = EAM.Ajax.request({
              url: "GRIDDATA",
              params: {
                GRID_NAME: "XU0006",
                REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                LOV_ALIAS_NAME_1: "str",
                LOV_ALIAS_VALUE_1: vStr,
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

            if (
              vUser == vOwner ||
              vUser == vAssetman ||
              vUser == vDelegate ||
              vUser == "ALEACH" ||
              vUser == "MALI"
            ) {
              EAM.Builder.setFieldState(
                {
                  wspf_10_str_delegate: "optional",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Utils.debugMessage("Yes");
            } else {
              EAM.Builder.setFieldState(
                {
                  wspf_10_str_delegate: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Utils.debugMessage("No");
            }
          } else {
            EAM.Builder.setFieldState(
              {
                wspf_10_str_delegate: "protected",
              },
              vFormPanel.getForm().getFieldsAndButtons()
            );
            EAM.Utils.debugMessage("No");
          }
        }, //
      },
    };
  },
});
