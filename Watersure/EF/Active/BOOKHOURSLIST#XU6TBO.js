Ext.define("EAM.custom.external_xu6tbo", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=LST][isTabView=true] [name=selfiltervaluectrl]":
        {
          focus: function () {
            EAM.Utils.debugMessage("focus");
            var headers = Ext.select("div.x-column-header-inner").elements,
              lists = Ext.select("div.x-grid-cell-inner").elements;
            var i;
            for (i = 0; i < headers.length; i++) {
              switch (headers[i].innerText) {
                case "Mo":
                  var Mo = i;
                  break;
                case "Tu":
                  var Tu = i;
                  break;
                case "We":
                  var We = i;
                  break;
                case "Th":
                  var Th = i;
                  break;
                case "Fr":
                  var Fr = i;
                  break;
                case "LMo":
                  var LMo = i;
                  break;
                case "LTu":
                  var LTu = i;
                  break;
                case "LWe":
                  var LWe = i;
                  break;
                case "LTh":
                  var LTh = i;
                  break;
                case "LFr":
                  var LFr = i;
                  break;
                case "-1W":
                  var W1 = i;
                  break;
                case "0W":
                  var W0 = i;
                  break;
                case "-2W":
                  var W2 = i;
                  break;
                case "-3W":
                  var W3 = i;
                  break;
                case "-4W":
                  var W4 = i;
                  break;
              } //This switch goes through and determines which columns are which and stores the position for the ones i care about.  if you only wanted one column you would only need one case.

              //These for loops do it by column, this is easy and scalable, and very copy/pastable to other screens, my values are numbers stored as text so i convert to a number and use nested ternary expressions to do the colouring, you could easily use if statements etc for this too,
              //the clever part of this is the for loops, it starts in the list array at the column we care about, and then jumps to the next value based on the number of columns, essentially going down the list in a single column
              var j;
              for (j = Mo; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = Tu; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = We; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = Th; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = Fr; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = W0; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 38
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 45
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = LMo; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = LTu; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = LWe; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = LTh; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = LFr; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 7.6
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 9
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = W1; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 38
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 45
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = W2; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 38
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 45
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = W3; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 38
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 45
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
              for (j = W4; j < lists.length; j += headers.length) {
                Number(lists[j].innerText) < 1
                  ? ((lists[j].style.backgroundColor = "#FFE4E1"),
                    (lists[j].style.color = "#000000"))
                  : Number(lists[j].innerText) < 38
                  ? ((lists[j].style.backgroundColor = "#FFFFF0"),
                    (lists[j].style.color = "#DAA520"))
                  : Number(lists[j].innerText) < 45
                  ? ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#556B2F"))
                  : ((lists[j].style.backgroundColor = "#F0FFF0"),
                    (lists[j].style.color = "#FF0000"));
              }
            }
          },
        },
    };
  },
});
