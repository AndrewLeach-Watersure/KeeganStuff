Ext.define("EAM.custom.external_pspord", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=udfchar03]": {
        blur: function (field, lastValues) {
          var vFormPanel = field.formPanel,
            vPO = vFormPanel.getForm().findField("ordercode").getValue();
          EAM.Utils.debugMessage(vPO);

          var response = EAM.Ajax.request({
            url: "GRIDDATA",
            params: {
              GRID_NAME: "XU0001",
              REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
              LOV_ALIAS_NAME_1: "ponumber",
              LOV_ALIAS_VALUE_1: vPO,
              LOV_ALIAS_TYPE_1: "",
            },
            async: false,
            method: "POST",
          });
          EAM.Utils.debugMessage(response);

          var mainGridStore = Ext.create("Ext.data.Store", {
            storeId: "poAddDetails",
            fields:
              response.responseData.pageData.grid.GRIDRESULT.GRID.FIELDS.FIELD,
            data: response.responseData.pageData.grid.GRIDRESULT.GRID.DATA,
          });
          EAM.Utils.debugMessage(
            response.responseData.pageData.grid.GRIDRESULT.GRID.FIELDS.FIELD
          );
          EAM.Utils.debugMessage(
            response.responseData.pageData.grid.GRIDRESULT.GRID.DATA
          );
          var PENIS = Ext.create("Ext.window.Window", {
            /*This is what creates the pop-up window, i think there are better wways to do it where you create it as a function and call it later, but beyond my skills atm */
            title: "PO Additional Details",
            height: 400,
            width: 600,
            layout: "fit",
            maximizable: true,
            bodyStyle: "background-color:#F0F0F0;padding: 10px",
            items: [
              {
                /* All the below are different parts of the popup window, some are like cells in a table used to format the information nicely, and also set defaults for fields in the containers */
                xtype: "grid",
                border: false,
                columns: [
                  { text: "Equipment", dataIndex: "evt_object", flex: 1 },
                  {
                    text: "Description",
                    dataIndex: "obj_desc",
                    flex: 1,
                  },
                  {
                    text: "Bdg Class",
                    dataIndex: "obj_udfchar34",
                    flex: 1,
                  },
                  {
                    text: "Strategy",
                    dataIndex: "obj_udfchar39",
                    flex: 1,
                  },
                  {
                    text: "Project",
                    dataIndex: "evt_project",
                    flex: 1,
                  },
                  {
                    text: "GL Code",
                    dataIndex: "orl_costcode",
                    flex: 1,
                  },
                ],
                store: mainGridStore,
              },
            ],
          }).show();
        },
      },
    };
  },
});
