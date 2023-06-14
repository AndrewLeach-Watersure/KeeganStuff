Ext.define("EAM.custom.external_PSINVO", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR]": {
        aftersaverecord: function (field, lastValues) {
          EAM.Utils.debugMessage("aftersaverecord");
          if (typeof EAM.Utils.getCurrentTab().getFormPanel === "function") {
            EAM.Utils.debugMessage("Type of Function");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vUser = gAppData.installParams.user,
              vType = vFormPanel.getFldValue("invoicetype"),
              vStatus = vFormPanel.getFldValue("invoicestatus");
            EAM.Utils.debugMessage(vType);
            EAM.Utils.debugMessage(vStatus);
            if (vType == "N" && vStatus == "U") {
              EAM.Builder.setFieldState(
                { udfchar01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar02: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar03: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vStatus == "A" && vUser == "ALEACH") {
              EAM.Builder.setFieldState(
                { udfchkbox01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          }
        },
      },
      "[extensibleFramework] [tabName=HDR]": {
        afterrecordchange: function (field, lastValues) {
          EAM.Utils.debugMessage("afterrecordchange");
          if (typeof EAM.Utils.getCurrentTab().getFormPanel === "function") {
            EAM.Utils.debugMessage("Type of Function");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vUser = gAppData.installParams.user,
              vType = vFormPanel.getFldValue("invoicetype"),
              vStatus = vFormPanel.getFldValue("invoicestatus");
            EAM.Utils.debugMessage(vType);
            EAM.Utils.debugMessage(vStatus);
            if (vType == "N" && vStatus == "U") {
              EAM.Builder.setFieldState(
                { udfchar01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar02: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar03: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vStatus == "A" && vUser == "ALEACH") {
              EAM.Builder.setFieldState(
                { udfchkbox01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          }
        },
      },
      "[extensibleFramework] [tabName=HDR][isTabView=true]": {
        afterloaddata: function (field, lastValues) {
          EAM.Utils.debugMessage("afterrecordchange");
          if (typeof EAM.Utils.getCurrentTab().getFormPanel === "function") {
            EAM.Utils.debugMessage("Type of Function");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vUser = gAppData.installParams.user,
              vType = vFormPanel.getFldValue("invoicetype"),
              vStatus = vFormPanel.getFldValue("invoicestatus");
            EAM.Utils.debugMessage(vType);
            EAM.Utils.debugMessage(vStatus);
            if (vType == "N" && vStatus == "U") {
              EAM.Builder.setFieldState(
                { udfchar01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar02: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar03: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vStatus == "A" && vUser == "ALEACH") {
              EAM.Builder.setFieldState(
                { udfchkbox01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          }
        },
      },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=invoicetype]":
        {
          select: function (field, lastValues) {
            EAM.Utils.debugMessage("invoicetype select");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vUser = gAppData.installParams.user,
              vType = vFormPanel.getFldValue("invoicetype"),
              vStatus = vFormPanel.getFldValue("invoicestatus");
            EAM.Utils.debugMessage(vType);
            EAM.Utils.debugMessage(vStatus);
            if (vType == "N" && vStatus == "U") {
              EAM.Builder.setFieldState(
                { udfchar01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar02: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar03: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vStatus == "A" && vUser == "ALEACH") {
              EAM.Builder.setFieldState(
                { udfchkbox01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          },
        },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=suppliercode]":
        {
          blur: function (field, lastValues) {
            EAM.Utils.debugMessage("invoicetype select");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vUser = gAppData.installParams.user,
              vType = vFormPanel.getFldValue("invoicetype"),
              vStatus = vFormPanel.getFldValue("invoicestatus");
            EAM.Utils.debugMessage(vType);
            EAM.Utils.debugMessage(vStatus);
            if (vType == "N" && vStatus == "U") {
              EAM.Builder.setFieldState(
                { udfchar01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar02: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar03: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vStatus == "A" && vUser == "ALEACH") {
              EAM.Builder.setFieldState(
                { udfchkbox01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          },
        },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=description]":
        {
          blur: function (field, lastValues) {
            EAM.Utils.debugMessage("invoicetype select");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vUser = gAppData.installParams.user,
              vType = vFormPanel.getFldValue("invoicetype"),
              vStatus = vFormPanel.getFldValue("invoicestatus");
            EAM.Utils.debugMessage(vType);
            EAM.Utils.debugMessage(vStatus);
            if (vType == "N" && vStatus == "U") {
              EAM.Builder.setFieldState(
                { udfchar01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar02: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { udfchar03: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vStatus == "A" && vUser == "ALEACH") {
              EAM.Builder.setFieldState(
                { udfchkbox01: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          },
        },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=invoicepurchaseorder]":
        {
          blur: function (field, lastValues) {
            EAM.Utils.debugMessage("invoice PO select");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vPO = vFormPanel.getFldValue("invoicepurchaseorder"),
              vDesc = vFormPanel.getFldValue("invoicedescription");
            EAM.Utils.debugMessage(vPO);
            EAM.Utils.debugMessage(vDesc);

            if (vDesc == "(DEFAULT INVOICE DESCRIPTION)" && vPO) {
              var response = EAM.Ajax.request({
                url: "GRIDDATA",
                params: {
                  GRID_NAME: "XU0043",
                  REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                  LOV_ALIAS_NAME_1: "po",
                  LOV_ALIAS_VALUE_1: vPO,
                  LOV_ALIAS_TYPE_1: "",
                },
                async: false,
                method: "POST",
              });

              if (response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]) {
                vDesc =
                  response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                    .ord_desc;
              }
            }
            vFormPanel.setFldValue("invoicedescription", vDesc, false);
          },
        },
      "[extensibleFramework] [tabName=IVL][isTabView=true]": {
        aftersaverecord: function (field, lastValues) {
          EAM.Utils.debugMessage("aftersave");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vPO = vFormPanel.getFldValue("purchaseorder"),
            vPoLine = vFormPanel.getFldValue("poline"),
            vCC = vFormPanel.getFldValue("udfchar05");

          var response = EAM.Ajax.request({
            url: "GRIDDATA",
            params: {
              GRID_NAME: "XU0044",
              REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
              LOV_ALIAS_NAME_1: "po",
              LOV_ALIAS_VALUE_1: vPO,
              LOV_ALIAS_TYPE_1: "",
              LOV_ALIAS_NAME_2: "poline",
              LOV_ALIAS_VALUE_2: vPoLine,
              LOV_ALIAS_TYPE_2: "",
            },
            async: false,
            method: "POST",
          });

          if (response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]) {
            vCC =
              response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                .orl_udfchar07;
          }
          EAM.Utils.debugMessage(vCC);
          vFormPanel.setFldValue("udfchar05", vCC, true);
        },
      },
      "[extensibleFramework] [tabName=IVL][isTabView=true]": {
        afterrecordchange: function (field, lastValues) {
          EAM.Utils.debugMessage("afterrecordchange");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vPO = vFormPanel.getFldValue("purchaseorder"),
            vPoLine = vFormPanel.getFldValue("poline"),
            vCC = vFormPanel.getFldValue("udfchar05");

          var response = EAM.Ajax.request({
            url: "GRIDDATA",
            params: {
              GRID_NAME: "XU0044",
              REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
              LOV_ALIAS_NAME_1: "po",
              LOV_ALIAS_VALUE_1: vPO,
              LOV_ALIAS_TYPE_1: "",
              LOV_ALIAS_NAME_2: "poline",
              LOV_ALIAS_VALUE_2: vPoLine,
              LOV_ALIAS_TYPE_2: "",
            },
            async: false,
            method: "POST",
          });

          if (response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]) {
            vCC =
              response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                .orl_udfchar07;
          }
          EAM.Utils.debugMessage(vCC);
          vFormPanel.setFldValue("udfchar05", vCC, true);
        },
      },
      "[extensibleFramework] [tabName=IVL][isTabView=true]": {
        afterloaddata: function (field, lastValues) {
          EAM.Utils.debugMessage("afterloaddata");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vPO = vFormPanel.getFldValue("purchaseorder"),
            vPoLine = vFormPanel.getFldValue("poline"),
            vCC = vFormPanel.getFldValue("udfchar05");

          var response = EAM.Ajax.request({
            url: "GRIDDATA",
            params: {
              GRID_NAME: "XU0044",
              REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
              LOV_ALIAS_NAME_1: "po",
              LOV_ALIAS_VALUE_1: vPO,
              LOV_ALIAS_TYPE_1: "",
              LOV_ALIAS_NAME_2: "poline",
              LOV_ALIAS_VALUE_2: vPoLine,
              LOV_ALIAS_TYPE_2: "",
            },
            async: false,
            method: "POST",
          });

          if (response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]) {
            vCC =
              response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                .orl_udfchar07;
          }
          EAM.Utils.debugMessage(vCC);
          vFormPanel.setFldValue("udfchar05", vCC, true);
        },
      },
      "[extensibleFramework] [tabName=IVL][isTabView=true] [name=poline]": {
        blur: function (field, lastValues) {
          EAM.Utils.debugMessage("poline");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vPO = vFormPanel.getFldValue("purchaseorder"),
            vPoLine = vFormPanel.getFldValue("poline"),
            vCC = vFormPanel.getFldValue("udfchar05");

          var response = EAM.Ajax.request({
            url: "GRIDDATA",
            params: {
              GRID_NAME: "XU0044",
              REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
              LOV_ALIAS_NAME_1: "po",
              LOV_ALIAS_VALUE_1: vPO,
              LOV_ALIAS_TYPE_1: "",
              LOV_ALIAS_NAME_2: "poline",
              LOV_ALIAS_VALUE_2: vPoLine,
              LOV_ALIAS_TYPE_2: "",
            },
            async: false,
            method: "POST",
          });

          if (response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]) {
            vCC =
              response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                .orl_udfchar07;
          }
          EAM.Utils.debugMessage(vCC);
          vFormPanel.setFldValue("udfchar05", vCC, true);
        },
      },

      "[extensibleFramework] [tabName=IVD][isTabView=true]": {
        aftersaverecord: function (field, lastValues) {
          EAM.Utils.debugMessage("aftersave");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel();
          EAM.Builder.setFieldState(
            { taxcode1: "optional" },
            vFormPanel.getForm().getFieldsAndButtons()
          );
        },
      },
      "[extensibleFramework] [tabName=IVD][isTabView=true]": {
        afterrecordchange: function (field, lastValues) {
          EAM.Utils.debugMessage("afterrecordchange");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel();
          EAM.Builder.setFieldState(
            { taxcode1: "optional" },
            vFormPanel.getForm().getFieldsAndButtons()
          );
        },
      },
      "[extensibleFramework] [tabName=IVD][isTabView=true]": {
        afterloaddata: function (field, lastValues) {
          EAM.Utils.debugMessage("afterloaddata");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel();
          EAM.Builder.setFieldState(
            { taxcode1: "optional" },
            vFormPanel.getForm().getFieldsAndButtons()
          );
        },
      },
      "[extensibleFramework] [tabName=IVD][isTabView=true] [name=extchgtype]": {
        blur: function (field, lastValues) {
          EAM.Utils.debugMessage("extchgtype");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel();
          EAM.Builder.setFieldState(
            { taxcode1: "optional" },
            vFormPanel.getForm().getFieldsAndButtons()
          );
        },
      },
    };
  },
});
