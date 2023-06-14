vFormPanel = EAM.Utils.getCurrentTab().getFormPanel();
EAM.Builder.setFieldState(
  {
    description: "optional",
    pmtype: "optional",
    pmwotype: "optional",
    duration: "optional",
    woclass: "optional",
    udfchar09: "optional",
    udfchar21: "optional",
    udfchar08: "optional",
    supervisor: "optional",
    priority: "optional",
    periodinterval: "optional",
    nestingreference: "optional",
    periodbufferback: "optional",
    completestatus: "optional",
    performonweek: "optional",
    performonday: "optional"
  },
  vFormPanel.getForm().getFieldsAndButtons()
);

document.getElementsByName("udfdate09")[0].style.background = "green";
document.getElementsByName("udfchkbox19")[0].style.background = "red";
document.getElementsByName("udfchar33")[0].style.background = "red";

