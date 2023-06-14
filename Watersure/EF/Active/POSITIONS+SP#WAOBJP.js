Ext.define("EAM.custom.external_WAOBJP", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true]": {
        afterloaddata: function (field, lastValues) {
          EAM.Utils.debugMessage("afterloaddata");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vClass = vFormPanel.getFldValue("class"),
            vSts = vFormPanel.getFldValue("assetstatus"),
            vUser = gAppData.installParams.user;
          if (vClass == "*") {
            vClass = null;
          }
          EAM.Builder.setFieldState(
            {
              "cust_3_RENT_OBJ_AFD-0047HUBN": "protected",
              cust_3_NUM_OBJ_CHANNELN: "protected",
              cust_3_RENT_OBJ_CONNECTI: "protected",
              cust_3_RENT_OBJ_CONTROLP: "protected",
              cust_3_NUM_OBJ_DPNODEAD: "protected",
              "cust_3_RENT_OBJ_DP-0047DPCOU": "protected",
              "cust_3_RENT_OBJ_DP-0047PACOU": "protected",
              cust_3_CHAR_OBJ_FAILSTAT: "protected",
              cust_3_RENT_OBJ_FIELDPAN: "protected",
              cust_3_CHAR_OBJ_GSDTYPE: "protected",
              cust_3_RENT_OBJ_JUNCTION: "protected",
              cust_3_CHAR_OBJ_LOCATION: "protected",
              cust_3_CHAR_OBJ_NATUREOF: "protected",
              "cust_3_NUM_OBJ_NOSLOTS-0047": "protected",
              cust_3_NUM_OBJ_PANODEAD: "protected",
              cust_3_RENT_OBJ_PLCNUMBE: "protected",
              cust_3_NUM_OBJ_PLCSLOTN: "protected",
              cust_3_RENT_OBJ_RACKNO: "protected",
              cust_3_NUM_OBJ_RACKSLOT: "protected",
              cust_3_NUM_OBJ_SLOTNO: "protected",
              cust_3_CHAR_OBJ_VENDORSU: "protected",
              cust_3_NUM_OBJ_AFDTEMP1: "protected",
              cust_3_NUM_OBJ_AFDTEMP2: "protected",
              cust_3_CHAR_PROJ_PROJTYPE: "protected",
              cust_3_CHAR_OBJ_GIVEN: "protected",
              cust_3_NUM_OBJ_MBTCPSL: "protected",
              cust_3_CHAR_OBJ_IPADDRES: "protected",
              cust_3_CHAR_OBJ_FIR_DVNU: "protected",
              cust_3_CHAR_OBJ_FIR_ZON: "protected",
              cust_3_CHAR_OBJ_CBL_AREA: "protected",
              cust_3_CHAR_OBJ_CBL_DEST: "protected",
              cust_3_NUM_OBJ_CBL_LENG: "protected",
              cust_3_CHAR_OBJ_AIR: "protected",
              cust_3_CHAR_OBJ_MATTYPE: "protected",
              cust_3_CHAR_OBJ_TOPENTRY: "protected",
              cust_3_CHAR_OBJ_240V: "protected",
              cust_3_CHAR_OBJ_CTRATIO: "protected",
              cust_3_CHAR_OBJ_FIR_TYP: "protected",
              cust_3_CHAR_OBJ_CBL_ORIG: "protected",
              cust_3_CHAR_OBJ_CBL_ZONE: "protected",
              cust_3_CHAR_OBJ_ENVIRO: "protected",
              cust_3_NUM_OBJ_AFDTEMP3: "protected",
              cust_3_CHAR_OBJ_FIR_INFL: "protected",
              cust_3_CHAR_OBJ_FIR_NOD: "protected",
              cust_3_CHAR_OBJ_CBL_ROUT: "protected",
              cust_3_CHAR_OBJ_CBL_SUBA: "protected",
              cust_3_CHAR_OBJ_CBL_TYPE: "protected",
            },
            vFormPanel.getForm().getFieldsAndButtons()
          );

          if (vClass && vSts != "D") {
            var response = EAM.Ajax.request({
              url: "GRIDDATA",
              params: {
                GRID_NAME: "XU0006",
                REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                LOV_ALIAS_NAME_1: "class",
                LOV_ALIAS_VALUE_1: vClass,
                LOV_ALIAS_TYPE_1: "",
              },
              async: false,
              method: "POST",
            });

            if (response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]) {
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
                    .str_delegate),
                (vBdg =
                  response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                    .bcl_code);
            } else {
              (vOwner = null),
                (vAssetman = null),
                (vStrategy = null),
                (vDelegate = null),
                (vBdg = null);
            }

            EAM.Utils.debugMessage(vOwner);
            EAM.Utils.debugMessage(vAssetman);
            EAM.Utils.debugMessage(vStrategy);
            EAM.Utils.debugMessage(vDelegate);

            vFormPanel.setFldValue("udfchar39", vStrategy, false),
              vFormPanel.setFldValue("udfchar32", vOwner, false),
              vFormPanel.setFldValue("udfchar34", vBdg, false);

            if (vUser == vOwner || vUser == vAssetman || vUser == vDelegate) {
              EAM.Builder.setFieldState(
                {
                  equipmentdesc: "optional",
                  udfchar29: "optional",
                  udfchar27: "optional",
                  udfchar35: "optional",
                  department: "optional",
                  eqtype: "optional",
                  udfchar33: "optional",
                  assetstatus: "optional",
                  udfchar25: "optional",
                  operationalstatus: "optional",
                  production: "optional",
                  safety: "optional",
                  udfchkbox03: "optional",
                  outofservice: "optional",
                  udfchkbox01: "optional",
                  udfchar21: "optional",
                  udfchkbox05: "optional",
                  udfchkbox02: "optional",
                  commissiondate: "optional",
                  assignedto: "optional",
                  dormantstart: "optional",
                  dormantend: "optional",
                  reusedormantperiod: "optional",
                  geographicalreference: "optional",
                  udfchar18: "optional",
                  udfchar20: "optional",
                  udfchar22: "optional",
                  udfchar24: "optional",
                  udfchar31: "optional",
                  udfchar41: "optional",
                  manufacturer: "optional",
                  model: "optional",
                  serialnumber: "optional",
                  udfchar23: "optional",
                  servicelife: "optional",
                  udfnum01: "optional",
                  udfchar01: "optional",
                  udfchar02: "optional",
                  udfchar12: "optional",
                  udfchar16: "optional",
                  udfchar17: "optional",
                  udfchar03: "optional",
                  udfchar04: "optional",
                  udfchar05: "optional",
                  udfchar06: "optional",
                  udfchar07: "optional",
                  udfchar08: "optional",
                  udfchar09: "optional",
                  udfchar10: "optional",
                  udfchar11: "optional",
                  asset: "optional",
                  dependentonasset: "optional",
                  costrollupasset: "optional",
                  location: "optional",
                  primarysystem: "optional",
                  dependentonsystem: "optional",
                  costrollupsystem: "optional",
                  parentasset: "optional",
                  dependentonparentasset: "optional",
                  costrollupparentasset: "optional",
                  udfchar19: "optional",
                  reliabilityrank: "optional",
                  servicelifeusage: "optional",
                  class: "optional",
                  udfchar34: "optional",
                  udfchar39: "optional",
                  category: "optional",
                  costcode: "optional",
                  "cust_3_RENT_OBJ_AFD-0047HUBN": "optional",
                  cust_3_NUM_OBJ_CHANNELN: "optional",
                  cust_3_RENT_OBJ_CONNECTI: "optional",
                  cust_3_RENT_OBJ_CONTROLP: "optional",
                  cust_3_NUM_OBJ_DPNODEAD: "optional",
                  "cust_3_RENT_OBJ_DP-0047DPCOU": "optional",
                  "cust_3_RENT_OBJ_DP-0047PACOU": "optional",
                  cust_3_CHAR_OBJ_FAILSTAT: "optional",
                  cust_3_RENT_OBJ_FIELDPAN: "optional",
                  cust_3_CHAR_OBJ_GSDTYPE: "optional",
                  cust_3_RENT_OBJ_JUNCTION: "optional",
                  cust_3_CHAR_OBJ_LOCATION: "optional",
                  cust_3_CHAR_OBJ_NATUREOF: "optional",
                  "cust_3_NUM_OBJ_NOSLOTS-0047": "optional",
                  cust_3_NUM_OBJ_PANODEAD: "optional",
                  cust_3_RENT_OBJ_PLCNUMBE: "optional",
                  cust_3_NUM_OBJ_PLCSLOTN: "optional",
                  cust_3_RENT_OBJ_RACKNO: "optional",
                  cust_3_NUM_OBJ_RACKSLOT: "optional",
                  cust_3_NUM_OBJ_SLOTNO: "optional",
                  cust_3_CHAR_OBJ_VENDORSU: "optional",
                  cust_3_NUM_OBJ_AFDTEMP1: "optional",
                  cust_3_NUM_OBJ_AFDTEMP2: "optional",
                  cust_3_CHAR_PROJ_PROJTYPE: "optional",
                  cust_3_CHAR_OBJ_GIVEN: "optional",
                  cust_3_NUM_OBJ_MBTCPSL: "optional",
                  cust_3_CHAR_OBJ_IPADDRES: "optional",
                  cust_3_CHAR_OBJ_FIR_DVNU: "optional",
                  cust_3_CHAR_OBJ_FIR_ZON: "optional",
                  cust_3_CHAR_OBJ_CBL_AREA: "optional",
                  cust_3_CHAR_OBJ_CBL_DEST: "optional",
                  cust_3_NUM_OBJ_CBL_LENG: "optional",
                  cust_3_CHAR_OBJ_AIR: "optional",
                  cust_3_CHAR_OBJ_MATTYPE: "optional",
                  cust_3_CHAR_OBJ_TOPENTRY: "optional",
                  cust_3_CHAR_OBJ_240V: "optional",
                  cust_3_CHAR_OBJ_CTRATIO: "optional",
                  cust_3_CHAR_OBJ_FIR_TYP: "optional",
                  cust_3_CHAR_OBJ_CBL_ORIG: "optional",
                  cust_3_CHAR_OBJ_CBL_ZONE: "optional",
                  cust_3_CHAR_OBJ_ENVIRO: "optional",
                  cust_3_NUM_OBJ_AFDTEMP3: "optional",
                  cust_3_CHAR_OBJ_FIR_INFL: "optional",
                  cust_3_CHAR_OBJ_FIR_NOD: "optional",
                  cust_3_CHAR_OBJ_CBL_ROUT: "optional",
                  cust_3_CHAR_OBJ_CBL_SUBA: "optional",
                  cust_3_CHAR_OBJ_CBL_TYPE: "optional",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          } else {
            EAM.Builder.setFieldState(
              {
                equipmentdesc: "optional",
                udfchar29: "optional",
                udfchar27: "optional",
                udfchar35: "optional",
                department: "optional",
                eqtype: "optional",
                udfchar33: "optional",
                assetstatus: "optional",
                udfchar25: "optional",
                operationalstatus: "optional",
                production: "optional",
                safety: "optional",
                udfchkbox03: "optional",
                outofservice: "optional",
                udfchkbox01: "optional",
                udfchar21: "optional",
                udfchkbox05: "optional",
                udfchkbox02: "optional",
                commissiondate: "optional",
                assignedto: "optional",
                dormantstart: "optional",
                dormantend: "optional",
                reusedormantperiod: "optional",
                geographicalreference: "optional",
                udfchar18: "optional",
                udfchar20: "optional",
                udfchar22: "optional",
                udfchar24: "optional",
                udfchar31: "optional",
                udfchar41: "optional",
                manufacturer: "optional",
                model: "optional",
                serialnumber: "optional",
                udfchar23: "optional",
                servicelife: "optional",
                udfnum01: "optional",
                udfchar01: "optional",
                udfchar02: "optional",
                udfchar12: "optional",
                udfchar16: "optional",
                udfchar17: "optional",
                udfchar03: "optional",
                udfchar04: "optional",
                udfchar05: "optional",
                udfchar06: "optional",
                udfchar07: "optional",
                udfchar08: "optional",
                udfchar09: "optional",
                udfchar10: "optional",
                udfchar11: "optional",
                asset: "optional",
                dependentonasset: "optional",
                costrollupasset: "optional",
                location: "optional",
                primarysystem: "optional",
                dependentonsystem: "optional",
                costrollupsystem: "optional",
                parentasset: "optional",
                dependentonparentasset: "optional",
                costrollupparentasset: "optional",
                udfchar19: "optional",
                reliabilityrank: "optional",
                servicelifeusage: "optional",
                class: "optional",
                udfchar34: "optional",
                udfchar39: "optional",
                category: "optional",
                costcode: "optional",
                "cust_3_RENT_OBJ_AFD-0047HUBN": "optional",
                cust_3_NUM_OBJ_CHANNELN: "optional",
                cust_3_RENT_OBJ_CONNECTI: "optional",
                cust_3_RENT_OBJ_CONTROLP: "optional",
                cust_3_NUM_OBJ_DPNODEAD: "optional",
                "cust_3_RENT_OBJ_DP-0047DPCOU": "optional",
                "cust_3_RENT_OBJ_DP-0047PACOU": "optional",
                cust_3_CHAR_OBJ_FAILSTAT: "optional",
                cust_3_RENT_OBJ_FIELDPAN: "optional",
                cust_3_CHAR_OBJ_GSDTYPE: "optional",
                cust_3_RENT_OBJ_JUNCTION: "optional",
                cust_3_CHAR_OBJ_LOCATION: "optional",
                cust_3_CHAR_OBJ_NATUREOF: "optional",
                "cust_3_NUM_OBJ_NOSLOTS-0047": "optional",
                cust_3_NUM_OBJ_PANODEAD: "optional",
                cust_3_RENT_OBJ_PLCNUMBE: "optional",
                cust_3_NUM_OBJ_PLCSLOTN: "optional",
                cust_3_RENT_OBJ_RACKNO: "optional",
                cust_3_NUM_OBJ_RACKSLOT: "optional",
                cust_3_NUM_OBJ_SLOTNO: "optional",
                cust_3_CHAR_OBJ_VENDORSU: "optional",
                cust_3_NUM_OBJ_AFDTEMP1: "optional",
                cust_3_NUM_OBJ_AFDTEMP2: "optional",
                cust_3_CHAR_PROJ_PROJTYPE: "optional",
                cust_3_CHAR_OBJ_GIVEN: "optional",
                cust_3_NUM_OBJ_MBTCPSL: "optional",
                cust_3_CHAR_OBJ_IPADDRES: "optional",
                cust_3_CHAR_OBJ_FIR_DVNU: "optional",
                cust_3_CHAR_OBJ_FIR_ZON: "optional",
                cust_3_CHAR_OBJ_CBL_AREA: "optional",
                cust_3_CHAR_OBJ_CBL_DEST: "optional",
                cust_3_NUM_OBJ_CBL_LENG: "optional",
                cust_3_CHAR_OBJ_AIR: "optional",
                cust_3_CHAR_OBJ_MATTYPE: "optional",
                cust_3_CHAR_OBJ_TOPENTRY: "optional",
                cust_3_CHAR_OBJ_240V: "optional",
                cust_3_CHAR_OBJ_CTRATIO: "optional",
                cust_3_CHAR_OBJ_FIR_TYP: "optional",
                cust_3_CHAR_OBJ_CBL_ORIG: "optional",
                cust_3_CHAR_OBJ_CBL_ZONE: "optional",
                cust_3_CHAR_OBJ_ENVIRO: "optional",
                cust_3_NUM_OBJ_AFDTEMP3: "optional",
                cust_3_CHAR_OBJ_FIR_INFL: "optional",
                cust_3_CHAR_OBJ_FIR_NOD: "optional",
                cust_3_CHAR_OBJ_CBL_ROUT: "optional",
                cust_3_CHAR_OBJ_CBL_SUBA: "optional",
                cust_3_CHAR_OBJ_CBL_TYPE: "optional",
              },
              vFormPanel.getForm().getFieldsAndButtons()
            );
          }
        },
      },
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=class]": {
        blur: function (field, lastValues) {
          EAM.Utils.debugMessage("blur");
          var vFormPanel = EAM.Utils.getCurrentTab().getFormPanel(),
            vClass = vFormPanel.getFldValue("class"),
            vSts = vFormPanel.getFldValue("assetstatus"),
            vUser = gAppData.installParams.user;
          if (vClass == "*") {
            vClass = null;
          }
          EAM.Builder.setFieldState(
            {
              "cust_3_RENT_OBJ_AFD-0047HUBN": "protected",
              cust_3_NUM_OBJ_CHANNELN: "protected",
              cust_3_RENT_OBJ_CONNECTI: "protected",
              cust_3_RENT_OBJ_CONTROLP: "protected",
              cust_3_NUM_OBJ_DPNODEAD: "protected",
              "cust_3_RENT_OBJ_DP-0047DPCOU": "protected",
              "cust_3_RENT_OBJ_DP-0047PACOU": "protected",
              cust_3_CHAR_OBJ_FAILSTAT: "protected",
              cust_3_RENT_OBJ_FIELDPAN: "protected",
              cust_3_CHAR_OBJ_GSDTYPE: "protected",
              cust_3_RENT_OBJ_JUNCTION: "protected",
              cust_3_CHAR_OBJ_LOCATION: "protected",
              cust_3_CHAR_OBJ_NATUREOF: "protected",
              "cust_3_NUM_OBJ_NOSLOTS-0047": "protected",
              cust_3_NUM_OBJ_PANODEAD: "protected",
              cust_3_RENT_OBJ_PLCNUMBE: "protected",
              cust_3_NUM_OBJ_PLCSLOTN: "protected",
              cust_3_RENT_OBJ_RACKNO: "protected",
              cust_3_NUM_OBJ_RACKSLOT: "protected",
              cust_3_NUM_OBJ_SLOTNO: "protected",
              cust_3_CHAR_OBJ_VENDORSU: "protected",
              cust_3_NUM_OBJ_AFDTEMP1: "protected",
              cust_3_NUM_OBJ_AFDTEMP2: "protected",
              cust_3_CHAR_PROJ_PROJTYPE: "protected",
              cust_3_CHAR_OBJ_GIVEN: "protected",
              cust_3_NUM_OBJ_MBTCPSL: "protected",
              cust_3_CHAR_OBJ_IPADDRES: "protected",
              cust_3_CHAR_OBJ_FIR_DVNU: "protected",
              cust_3_CHAR_OBJ_FIR_ZON: "protected",
              cust_3_CHAR_OBJ_CBL_AREA: "protected",
              cust_3_CHAR_OBJ_CBL_DEST: "protected",
              cust_3_NUM_OBJ_CBL_LENG: "protected",
              cust_3_CHAR_OBJ_AIR: "protected",
              cust_3_CHAR_OBJ_MATTYPE: "protected",
              cust_3_CHAR_OBJ_TOPENTRY: "protected",
              cust_3_CHAR_OBJ_240V: "protected",
              cust_3_CHAR_OBJ_CTRATIO: "protected",
              cust_3_CHAR_OBJ_FIR_TYP: "protected",
              cust_3_CHAR_OBJ_CBL_ORIG: "protected",
              cust_3_CHAR_OBJ_CBL_ZONE: "protected",
              cust_3_CHAR_OBJ_ENVIRO: "protected",
              cust_3_NUM_OBJ_AFDTEMP3: "protected",
              cust_3_CHAR_OBJ_FIR_INFL: "protected",
              cust_3_CHAR_OBJ_FIR_NOD: "protected",
              cust_3_CHAR_OBJ_CBL_ROUT: "protected",
              cust_3_CHAR_OBJ_CBL_SUBA: "protected",
              cust_3_CHAR_OBJ_CBL_TYPE: "protected",
            },
            vFormPanel.getForm().getFieldsAndButtons()
          );

          if (vClass && vSts != "D") {
            var response = EAM.Ajax.request({
              url: "GRIDDATA",
              params: {
                GRID_NAME: "XU0006",
                REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                LOV_ALIAS_NAME_1: "class",
                LOV_ALIAS_VALUE_1: vClass,
                LOV_ALIAS_TYPE_1: "",
              },
              async: false,
              method: "POST",
            });
            if (response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]) {
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
                    .str_delegate),
                (vBdg =
                  response.responseData.pageData.grid.GRIDRESULT.GRID.DATA[0]
                    .bcl_code);
            } else {
              (vOwner = null),
                (vAssetman = null),
                (vStrategy = null),
                (vDelegate = null),
                (vBdg = null);
            }
            EAM.Utils.debugMessage(vOwner);
            EAM.Utils.debugMessage(vAssetman);
            EAM.Utils.debugMessage(vStrategy);
            EAM.Utils.debugMessage(vDelegate);

            vFormPanel.setFldValue("udfchar39", vStrategy, false),
              vFormPanel.setFldValue("udfchar32", vOwner, false),
              vFormPanel.setFldValue("udfchar34", vBdg, false);

            if (vUser == vOwner || vUser == vAssetman || vUser == vDelegate) {
              EAM.Builder.setFieldState(
                {
                  equipmentdesc: "optional",
                  udfchar29: "optional",
                  udfchar27: "optional",
                  udfchar35: "optional",
                  department: "optional",
                  eqtype: "optional",
                  udfchar33: "optional",
                  assetstatus: "optional",
                  udfchar25: "optional",
                  operationalstatus: "optional",
                  production: "optional",
                  safety: "optional",
                  udfchkbox03: "optional",
                  outofservice: "optional",
                  udfchkbox01: "optional",
                  udfchar21: "optional",
                  udfchkbox05: "optional",
                  udfchkbox02: "optional",
                  commissiondate: "optional",
                  assignedto: "optional",
                  dormantstart: "optional",
                  dormantend: "optional",
                  reusedormantperiod: "optional",
                  geographicalreference: "optional",
                  udfchar18: "optional",
                  udfchar20: "optional",
                  udfchar22: "optional",
                  udfchar24: "optional",
                  udfchar31: "optional",
                  udfchar41: "optional",
                  manufacturer: "optional",
                  model: "optional",
                  serialnumber: "optional",
                  udfchar23: "optional",
                  servicelife: "optional",
                  udfnum01: "optional",
                  udfchar01: "optional",
                  udfchar02: "optional",
                  udfchar12: "optional",
                  udfchar16: "optional",
                  udfchar17: "optional",
                  udfchar03: "optional",
                  udfchar04: "optional",
                  udfchar05: "optional",
                  udfchar06: "optional",
                  udfchar07: "optional",
                  udfchar08: "optional",
                  udfchar09: "optional",
                  udfchar10: "optional",
                  udfchar11: "optional",
                  asset: "optional",
                  dependentonasset: "optional",
                  costrollupasset: "optional",
                  location: "optional",
                  primarysystem: "optional",
                  dependentonsystem: "optional",
                  costrollupsystem: "optional",
                  parentasset: "optional",
                  dependentonparentasset: "optional",
                  costrollupparentasset: "optional",
                  udfchar19: "optional",
                  reliabilityrank: "optional",
                  servicelifeusage: "optional",
                  class: "optional",
                  udfchar34: "optional",
                  udfchar39: "optional",
                  category: "optional",
                  costcode: "optional",
                  "cust_3_RENT_OBJ_AFD-0047HUBN": "optional",
                  cust_3_NUM_OBJ_CHANNELN: "optional",
                  cust_3_RENT_OBJ_CONNECTI: "optional",
                  cust_3_RENT_OBJ_CONTROLP: "optional",
                  cust_3_NUM_OBJ_DPNODEAD: "optional",
                  "cust_3_RENT_OBJ_DP-0047DPCOU": "optional",
                  "cust_3_RENT_OBJ_DP-0047PACOU": "optional",
                  cust_3_CHAR_OBJ_FAILSTAT: "optional",
                  cust_3_RENT_OBJ_FIELDPAN: "optional",
                  cust_3_CHAR_OBJ_GSDTYPE: "optional",
                  cust_3_RENT_OBJ_JUNCTION: "optional",
                  cust_3_CHAR_OBJ_LOCATION: "optional",
                  cust_3_CHAR_OBJ_NATUREOF: "optional",
                  "cust_3_NUM_OBJ_NOSLOTS-0047": "optional",
                  cust_3_NUM_OBJ_PANODEAD: "optional",
                  cust_3_RENT_OBJ_PLCNUMBE: "optional",
                  cust_3_NUM_OBJ_PLCSLOTN: "optional",
                  cust_3_RENT_OBJ_RACKNO: "optional",
                  cust_3_NUM_OBJ_RACKSLOT: "optional",
                  cust_3_NUM_OBJ_SLOTNO: "optional",
                  cust_3_CHAR_OBJ_VENDORSU: "optional",
                  cust_3_NUM_OBJ_AFDTEMP1: "optional",
                  cust_3_NUM_OBJ_AFDTEMP2: "optional",
                  cust_3_CHAR_PROJ_PROJTYPE: "optional",
                  cust_3_CHAR_OBJ_GIVEN: "optional",
                  cust_3_NUM_OBJ_MBTCPSL: "optional",
                  cust_3_CHAR_OBJ_IPADDRES: "optional",
                  cust_3_CHAR_OBJ_FIR_DVNU: "optional",
                  cust_3_CHAR_OBJ_FIR_ZON: "optional",
                  cust_3_CHAR_OBJ_CBL_AREA: "optional",
                  cust_3_CHAR_OBJ_CBL_DEST: "optional",
                  cust_3_NUM_OBJ_CBL_LENG: "optional",
                  cust_3_CHAR_OBJ_AIR: "optional",
                  cust_3_CHAR_OBJ_MATTYPE: "optional",
                  cust_3_CHAR_OBJ_TOPENTRY: "optional",
                  cust_3_CHAR_OBJ_240V: "optional",
                  cust_3_CHAR_OBJ_CTRATIO: "optional",
                  cust_3_CHAR_OBJ_FIR_TYP: "optional",
                  cust_3_CHAR_OBJ_CBL_ORIG: "optional",
                  cust_3_CHAR_OBJ_CBL_ZONE: "optional",
                  cust_3_CHAR_OBJ_ENVIRO: "optional",
                  cust_3_NUM_OBJ_AFDTEMP3: "optional",
                  cust_3_CHAR_OBJ_FIR_INFL: "optional",
                  cust_3_CHAR_OBJ_FIR_NOD: "optional",
                  cust_3_CHAR_OBJ_CBL_ROUT: "optional",
                  cust_3_CHAR_OBJ_CBL_SUBA: "optional",
                  cust_3_CHAR_OBJ_CBL_TYPE: "optional",
                },
                vFormPanel.getForm().getFieldsAndButtons()
              );
            }
          } else {
            EAM.Builder.setFieldState(
              {
                equipmentdesc: "optional",
                udfchar29: "optional",
                udfchar27: "optional",
                udfchar35: "optional",
                department: "optional",
                eqtype: "optional",
                udfchar33: "optional",
                assetstatus: "optional",
                udfchar25: "optional",
                operationalstatus: "optional",
                production: "optional",
                safety: "optional",
                udfchkbox03: "optional",
                outofservice: "optional",
                udfchkbox01: "optional",
                udfchar21: "optional",
                udfchkbox05: "optional",
                udfchkbox02: "optional",
                commissiondate: "optional",
                assignedto: "optional",
                dormantstart: "optional",
                dormantend: "optional",
                reusedormantperiod: "optional",
                geographicalreference: "optional",
                udfchar18: "optional",
                udfchar20: "optional",
                udfchar22: "optional",
                udfchar24: "optional",
                udfchar31: "optional",
                udfchar41: "optional",
                manufacturer: "optional",
                model: "optional",
                serialnumber: "optional",
                udfchar23: "optional",
                servicelife: "optional",
                udfnum01: "optional",
                udfchar01: "optional",
                udfchar02: "optional",
                udfchar12: "optional",
                udfchar16: "optional",
                udfchar17: "optional",
                udfchar03: "optional",
                udfchar04: "optional",
                udfchar05: "optional",
                udfchar06: "optional",
                udfchar07: "optional",
                udfchar08: "optional",
                udfchar09: "optional",
                udfchar10: "optional",
                udfchar11: "optional",
                asset: "optional",
                dependentonasset: "optional",
                costrollupasset: "optional",
                location: "optional",
                primarysystem: "optional",
                dependentonsystem: "optional",
                costrollupsystem: "optional",
                parentasset: "optional",
                dependentonparentasset: "optional",
                costrollupparentasset: "optional",
                udfchar19: "optional",
                reliabilityrank: "optional",
                servicelifeusage: "optional",
                class: "optional",
                udfchar34: "optional",
                udfchar39: "optional",
                category: "optional",
                costcode: "optional",
                "cust_3_RENT_OBJ_AFD-0047HUBN": "optional",
                cust_3_NUM_OBJ_CHANNELN: "optional",
                cust_3_RENT_OBJ_CONNECTI: "optional",
                cust_3_RENT_OBJ_CONTROLP: "optional",
                cust_3_NUM_OBJ_DPNODEAD: "optional",
                "cust_3_RENT_OBJ_DP-0047DPCOU": "optional",
                "cust_3_RENT_OBJ_DP-0047PACOU": "optional",
                cust_3_CHAR_OBJ_FAILSTAT: "optional",
                cust_3_RENT_OBJ_FIELDPAN: "optional",
                cust_3_CHAR_OBJ_GSDTYPE: "optional",
                cust_3_RENT_OBJ_JUNCTION: "optional",
                cust_3_CHAR_OBJ_LOCATION: "optional",
                cust_3_CHAR_OBJ_NATUREOF: "optional",
                "cust_3_NUM_OBJ_NOSLOTS-0047": "optional",
                cust_3_NUM_OBJ_PANODEAD: "optional",
                cust_3_RENT_OBJ_PLCNUMBE: "optional",
                cust_3_NUM_OBJ_PLCSLOTN: "optional",
                cust_3_RENT_OBJ_RACKNO: "optional",
                cust_3_NUM_OBJ_RACKSLOT: "optional",
                cust_3_NUM_OBJ_SLOTNO: "optional",
                cust_3_CHAR_OBJ_VENDORSU: "optional",
                cust_3_NUM_OBJ_AFDTEMP1: "optional",
                cust_3_NUM_OBJ_AFDTEMP2: "optional",
                cust_3_CHAR_PROJ_PROJTYPE: "optional",
                cust_3_CHAR_OBJ_GIVEN: "optional",
                cust_3_NUM_OBJ_MBTCPSL: "optional",
                cust_3_CHAR_OBJ_IPADDRES: "optional",
                cust_3_CHAR_OBJ_FIR_DVNU: "optional",
                cust_3_CHAR_OBJ_FIR_ZON: "optional",
                cust_3_CHAR_OBJ_CBL_AREA: "optional",
                cust_3_CHAR_OBJ_CBL_DEST: "optional",
                cust_3_NUM_OBJ_CBL_LENG: "optional",
                cust_3_CHAR_OBJ_AIR: "optional",
                cust_3_CHAR_OBJ_MATTYPE: "optional",
                cust_3_CHAR_OBJ_TOPENTRY: "optional",
                cust_3_CHAR_OBJ_240V: "optional",
                cust_3_CHAR_OBJ_CTRATIO: "optional",
                cust_3_CHAR_OBJ_FIR_TYP: "optional",
                cust_3_CHAR_OBJ_CBL_ORIG: "optional",
                cust_3_CHAR_OBJ_CBL_ZONE: "optional",
                cust_3_CHAR_OBJ_ENVIRO: "optional",
                cust_3_NUM_OBJ_AFDTEMP3: "optional",
                cust_3_CHAR_OBJ_FIR_INFL: "optional",
                cust_3_CHAR_OBJ_FIR_NOD: "optional",
                cust_3_CHAR_OBJ_CBL_ROUT: "optional",
                cust_3_CHAR_OBJ_CBL_SUBA: "optional",
                cust_3_CHAR_OBJ_CBL_TYPE: "optional",
              },
              vFormPanel.getForm().getFieldsAndButtons()
            );
          }
        },
      },
    };
  },
});
