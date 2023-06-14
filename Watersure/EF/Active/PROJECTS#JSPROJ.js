Ext.define("EAM.custom.external_jsproj", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=projectdesc]":
        {
          focus: function (field, lastValues) {
            EAM.Utils.debugMessage("Focus");
            var vFormPanel = field.formPanel;
            {
              document.getElementsByName("udfchar01")[0].style.width = "521px";
              document.getElementsByName("udfchar02")[0].style.width = "521px";
            }
          },
        },
    };
  },
});
