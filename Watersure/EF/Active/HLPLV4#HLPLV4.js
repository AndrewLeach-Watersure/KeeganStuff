Ext.define("EAM.custom.external_HLPLV4", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=filtername]": {
        focus: function (field, lastValues) {
          var vFormPanel = field.formPanel,
            vStart = vFormPanel.getFldValue("genfromdate"),
            vEnd = vFormPanel.getFldValue("genthrudate");

          document.getElementsByName("genfromdate")[0].value = Ext.Date.format(
            Ext.Date.getFirstDateOfMonth(vStart),
            "d/M/Y"
          );
          document.getElementsByName("genthrudate")[0].value = Ext.Date.format(
            Ext.Date.getLastDateOfMonth(vEnd),
            "d-M-Y"
          );
          document.getElementsByName("genfromdate")[0].select();
          document.getElementsByName("genthrudate")[0].select();
          document.getElementsByName("genfromdate")[0].select();
          document.getElementsByName("genthrudate")[0].select();
          EAM.Utils.debugMessage("focus");
        },
      },
    };
  },
});
