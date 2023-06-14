Ext.define("EAM.custom.external_wsjobs", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true]": {
        afterloaddata: function (field, lastValues) {
          EAM.Utils.debugMessage("afterloaddata");
          if (typeof EAM.Utils.getCurrentTab().getFormPanel === "function") {
            EAM.Utils.debugMessage("Type of Function");
            var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
              vUser = gAppData.installParams.user,
              vCC = vFormPanel.getFldValue("department");
            EAM.Utils.debugMessage(vCC);
            if (vUser == "ALEACH" || vUser == "MALI") {
              EAM.Builder.setFieldState(
                { equipment: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (
              vUser == "ALEACH" ||
              vUser == "JREID" ||
              vUser == "DFRISWELL" ||
              vUser == "BLEE"
            ) {
              EAM.Builder.setFieldState(
                { udfchkbox07: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vCC == "MRA" || vCC == "PRO" || vCC == "DEF") {
              EAM.Builder.setFieldState(
                { project: "required" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { projbud: "required" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (!(vCC == "MRA" || vCC == "PRO" || vCC == "DEF")) {
              EAM.Builder.setFieldState(
                { project: "protected" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { projbud: "protected" },
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
              vCC = vFormPanel.getFldValue("department");
            EAM.Utils.debugMessage(vCC);
            if (vUser == "ALEACH") {
              EAM.Builder.setFieldState(
                { equipment: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (
              vUser == "ALEACH" ||
              vUser == "JREID" ||
              vUser == "DFRISWELL" ||
              vUser == "BLEE"
            ) {
              EAM.Builder.setFieldState(
                { udfchkbox07: "optional" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (vCC == "MRA" || vCC == "PRO" || vCC == "DEF") {
              EAM.Builder.setFieldState(
                { project: "required" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { projbud: "required" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (!(vCC == "MRA" || vCC == "PRO" || vCC == "DEF")) {
              EAM.Builder.setFieldState(
                { project: "protected" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                { projbud: "protected" },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          }
        },
      },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=description]":
        {
          blur: function (field, lastValues) {
            EAM.Utils.debugMessage("Focus");
            var vFormPanel = field.formPanel,
              vStat = vFormPanel.getFldValue("udfchar06"),
              vStat2 = vFormPanel.getFldValue("workorderstatus"),
              vType = vFormPanel.getFldValue("workordertype"),
              vCre = vFormPanel.getFldValue("datecreated");
            EAM.Utils.debugMessage(vStat);
            EAM.Utils.debugMessage(vType);
            EAM.Utils.debugMessage(vCre);
            {
              EAM.Builder.setFieldState(
                {
                  workordertype: "optional",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                {
                  udfdate02: "optional",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (
              !(
                vStat == "RQST" ||
                (vCre == null && vStat2 == "RQST") ||
                (vCre == null && vStat2 == null)
              )
            ) {
              EAM.Builder.setFieldState(
                {
                  workordertype: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                {
                  department: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                {
                  udfdate02: "required",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
            if (
              !(
                vStat == "RQST" ||
                (vCre == null && vStat2 == "RQST") ||
                (vCre == null && vStat2 == null)
              ) &&
              (vType == "CMCH" ||
                vType == "EMIN" ||
                vType == "EMPM" ||
                vType == "EMTM")
            ) {
              EAM.Builder.setFieldState(
                {
                  udfchar21: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                {
                  schedgroup: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              /* EAM.Builder.setFieldState(
                {
                  udfdate02: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
              EAM.Builder.setFieldState(
                {
                  udfdate03: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              ); */ //lock due dates when Change, turned off temporarily to set dates on non-change Eng Mods
              EAM.Builder.setFieldState(
                {
                  udfchar15: "protected",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          },
        },
      "[extensibleFramework] [tabName=BOO][isTabView=true] [name=employee]": {
        focus: function (field, lastValues) {
          EAM.Utils.debugMessage("Afterload");
          var vFormPanel = field.formPanel;
          document.getElementsByName("boodescription")[0].style.width = "500px";
        },
      },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=priority]": {
        blur: function (field, lastValues) {
          EAM.Utils.debugMessage("priority");
          var vFormPanel = field.formPanel,
            vPri = vFormPanel.getFldValue("priority"),
            vDue = vFormPanel.getFldValue("udfdate02"),
            vCreated = vFormPanel.getFldValue("datecreated"),
            vStatus = vFormPanel.getFldValue("workorderstatus");
          if (vCreated == null) {
            vCreated = new Date();
          }
          EAM.Utils.debugMessage(vCreated);
          EAM.Utils.debugMessage(vDue);
          if (vPri == 1 && vStatus == "RQST") {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(new Date(), Ext.Date.DAY, 7),
              "d/M/Y"
            );
            document.getElementsByName("udfdate03")[0].value = Ext.Date.format(
              Ext.Date.add(new Date(), Ext.Date.DAY, 7),
              "d/M/Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            document.getElementsByName("udfdate03")[0].select();
          }
          if (vPri == 2 && vStatus == "RQST") {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 1),
              "d/M/Y"
            );
            document.getElementsByName("udfdate03")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 1),
              "d/M/Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            document.getElementsByName("udfdate03")[0].select();
          }
          if (vPri == 3 && vStatus == "RQST") {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 3),
              "d/M/Y"
            );
            document.getElementsByName("udfdate03")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 3),
              "d/M/Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            document.getElementsByName("udfdate03")[0].select();
          }
          if (vPri == 4 && vStatus == "RQST") {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 12),
              "d/M/Y"
            );
            document.getElementsByName("udfdate03")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 12),
              "d/M/Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            document.getElementsByName("udfdate03")[0].select();
          }
        },
      },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=department]": {
        blur: function (field, lastValues) {
          EAM.Utils.debugMessage("department");
          var vFormPanel = field.formPanel,
            vCC = vFormPanel.getFldValue("department");
          if (vCC == "MRA" || vCC == "PRO" || vCC == "DEF") {
            EAM.Builder.setFieldState(
              { project: "required" },
              vFormPanel.getForm().getFieldsAndButtons()
            );
            EAM.Builder.setFieldState(
              { projbud: "required" },
              vFormPanel.getForm().getFieldsAndButtons()
            );
          }
          if (!(vCC == "MRA" || vCC == "PRO" || vCC == "DEF")) {
            EAM.Builder.setFieldState(
              { project: "protected" },
              vFormPanel.getForm().getFieldsAndButtons()
            );
            EAM.Builder.setFieldState(
              { projbud: "protected" },
              vFormPanel.getForm().getFieldsAndButtons()
            );
          }
        },
      },
    };
  },
});
