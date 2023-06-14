Ext.define("EAM.custom.external_ASSKPI", {
  extend: "EAM.custom.AbstractExtensibleFramework",
  getSelectors: function () {
    return {
      "[extensibleFramework] [tabName=HDR][isTabView=true] [name=filtername]": {
        afterrender: function (field, lastValues) {
          EAM.Utils.debugMessage("afterrender");
          //Change title
          document.getElementsByClassName("x-title-text")[0].textContent =
            "Asset KPI Below";

          EAM.Utils.debugMessage(
            EAM.Ajax.request({
              url: "GRIDDATA",
              params: {
                GRID_NAME: "XU1025",
                REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                LOV_ALIAS_NAME_1: "costCenter",
                LOV_ALIAS_VALUE_1: ["EI", "MEC"],
                LOV_ALIAS_NAME_2: "jobType",
                LOV_ALIAS_VALUE_2: "PM",
                LOV_ALIAS_NAME_3: "endDate",
                LOV_ALIAS_VALUE_3: "01-NOV-2022",
                LOV_ALIAS_NAME_4: "startDate",
                LOV_ALIAS_VALUE_4: "01-JAN-2022",
              },
              async: false,
              method: "POST",
            }).responseData.pageData.grid.GRIDRESULT.GRID.DATA
          );

          //Store
          Ext.define("KitchenSink.store.Pareto", {
            extend: "Ext.data.Store",
            alias: "store.pareto",

            fields: ["id", "date", "issued", "overdue", "closed"],

            constructor: function (config) {
              config = config || {};

              config.data = EAM.Ajax.request({
                url: "GRIDDATA",
                params: {
                  GRID_NAME: "XU1025",
                  REQUEST_TYPE: "LIST.HEAD_DATA.STORED",
                  LOV_ALIAS_NAME_1: "costCenter",
                  LOV_ALIAS_VALUE_1: ["EI", "MEC", "ENG"],
                  LOV_ALIAS_NAME_2: "jobType",
                  LOV_ALIAS_VALUE_2: ["PM", "CM"],
                  LOV_ALIAS_NAME_3: "endDate",
                  LOV_ALIAS_VALUE_3: "01-JAN-2023",
                  LOV_ALIAS_NAME_4: "startDate",
                  LOV_ALIAS_VALUE_4: "01-JAN-2022",
                },
                async: false,
                method: "POST",
              }).responseData.pageData.grid.GRIDRESULT.GRID.DATA;

              this.callParent([config]);
            },
          });
          //Controller
          Ext.define("KitchenSink.view.charts.combination.ParetoController", {
            extend: "Ext.app.ViewController",
            alias: "controller.combination-pareto",

            onDownload: function () {
              var chart;

              if (Ext.isIE8) {
                Ext.Msg.alert(
                  "Unsupported Operation",
                  "This operation requires a newer version of Internet Explorer."
                );

                return;
              }

              chart = this.lookup("chart");

              if (Ext.os.is.Desktop) {
                chart.download({
                  filename: "Asset KPI",
                });
              } else {
                chart.preview();
              }
            },

            onBarSeriesTooltipRender: function (tooltip, record, item) {
              tooltip.setHtml(
                record.get("date") +
                  ": " +
                  record.get("issued") +
                  " Issued." +
                  record.get("closed") +
                  " Closed."
              );
            },

            onLineSeriesTooltipRender: function (tooltip, record, item) {
              var store = record.store,
                i,
                dates = [];

              for (i = 0; i <= item.index; i++) {
                dates.push(store.getAt(i).get("date"));
              }

              tooltip.setHtml(
                '<div style="text-align: center; font-weight: bold">' +
                  record.get("overdue") +
                  " Overdue."
              );
            },
          });
          //View
          Ext.define("KitchenSink.view.charts.combination.Pareto", {
            extend: "Ext.Panel",
            requires: "Ext.chart.theme.Category2",
            xtype: "combination-pareto",
            controller: "combination-pareto",

            width: 650,

            profiles: {
              classic: {
                columnWidth: 100,
              },
              neptune: {
                columnWidth: 100,
              },
              graphite: {
                columnWidth: 150,
              },
            },
            dockedItems: [
              {
                xtype: "toolbar",
                dock: "top",
                items: [
                  "->",
                  {
                    text: Ext.os.is.Desktop ? "Download" : "Preview",
                    handler: "onDownload",
                  },
                ],
              },
            ],

            items: [
              {
                xtype: "cartesian",
                reference: "chart",
                downloadServerUrl: "//svg.sencha.io",
                theme: "category2",
                width: "100%",
                height: 500,
                store: {
                  type: "pareto",
                },
                legend: {
                  docked: "bottom",
                },
                captions: {
                  title: "Asset Work KPI",
                },
                axes: [
                  {
                    type: "numeric",
                    position: "left",
                    fields: ["issued", "closed"],
                    majorTickSteps: 10,
                    reconcileRange: true,
                    grid: true,
                    minimum: 0,
                  },
                  {
                    type: "category",
                    position: "bottom",
                    fields: "date",
                    label: {
                      rotate: {
                        degrees: -45,
                      },
                    },
                  },
                ],
                series: [
                  {
                    type: "bar",
                    stacked: false,
                    title: ["Issued", "Closed"],
                    xField: "date",
                    yField: ["issued", "closed"],
                    style: {
                      opacity: 0.8,
                    },
                    highlight: {
                      fillStyle: "rgba(204, 230, 73, 1.0)",
                      strokeStyle: "black",
                    },
                    tooltip: {
                      trackMouse: true,
                      renderer: "onBarSeriesTooltipRender",
                    },
                  },
                  {
                    type: "line",
                    title: "Overdue",
                    xField: "date",
                    yField: "overdue",
                    style: {
                      lineWidth: 2,
                      opacity: 0.8,
                    },
                    marker: {
                      type: "cross",
                      animation: {
                        duration: 200,
                      },
                    },
                    highlightCfg: {
                      scaling: 2,
                      rotationRads: Math.PI / 4,
                    },
                    tooltip: {
                      trackMouse: true,
                      renderer: "onLineSeriesTooltipRender",
                    },
                  },
                ],
              },
            ],
          });

          EAM.Utils.getElementComponent(
            document.getElementsByClassName("x-panel-body")[4]
          ).add(
            Ext.create("Ext.panel.Panel", {
              bodyPadding: 5,
              items: Ext.create(
                "KitchenSink.view.charts.combination.Pareto",
                {}
              ),
              renderTo: Ext.getBody(),
            })
          );
        },
      },
    };
  },
});
