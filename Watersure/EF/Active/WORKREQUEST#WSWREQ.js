Ext.define("EAM.custom.external_WSWREQ", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
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
          if (vPri == 1 && (vStatus == "Q" || vStatus == "QUNF")) {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(new Date(), Ext.Date.DAY, 7),
              "d-M-Y"
            );
            vFormPanel.setFldValue("workordertype", "CMPR", false);
            document.getElementsByName("description")[0].select();
          }
          if (vPri == 2 && (vStatus == "Q" || vStatus == "QUNF")) {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 1),
              "d-M-Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            vFormPanel.setFldValue("workordertype", "CMPR", false);
            document.getElementsByName("description")[0].select();
          }
          if (vPri == 3 && (vStatus == "Q" || vStatus == "QUNF")) {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 3),
              "d-M-Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            vFormPanel.setFldValue("workordertype", "CMPR", false);
            document.getElementsByName("description")[0].select();
          }
          if (vPri == 4 && (vStatus == "Q" || vStatus == "QUNF")) {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(vCreated, Ext.Date.MONTH, 12),
              "d-M-Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            vFormPanel.setFldValue("workordertype", "CMPR", false);
            document.getElementsByName("description")[0].select();
          }
          if (vPri == "BD") {
            document.getElementsByName("udfdate02")[0].value = Ext.Date.format(
              Ext.Date.add(new Date(), Ext.Date.DAY, 0),
              "d-M-Y"
            );
            document.getElementsByName("udfdate02")[0].select();
            vFormPanel.setFldValue("workordertype", "CMBD", false);
            document.getElementsByName("description")[0].select();
          }
        },
      },
    };
  },
});
