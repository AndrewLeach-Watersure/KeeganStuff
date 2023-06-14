 Ext.create('Ext.window.Window', {
   extend: 'Ext.Container',
   title: 'Grid Test',
   autoShow: true,
   height: 700,
   width: 700,
   scrollable: 'true',
   bodyPadding: 10,
   maximizable: true,
   bodyStyle: 'background-color:#F0F0F0;padding: 10px',
   items: [{
         xtype: 'polar',
         renderTo: document.body,
         shadow: 'true',
         reference: 'chart',
         width: 600,
         height: 600,
         store: {
           fields: ['name', 'g1', 'g2'],
           data: [{
             "name": "Item-0",
             "g1": 18.34,
             "g2": 0.04
           }, {
             "name": "Item-1",
             "g1": 2.67,
             "g2": 14.87
           }, {
             "name": "Item-2",
             "g1": 1.90,
             "g2": 5.72
           }, {
             "name": "Item-3",
             "g1": 21.37,
             "g2": 2.13
           }, {
             "name": "Item-4",
             "g1": 2.67,
             "g2": 8.53
           }, {
             "name": "Item-5",
             "g1": 18.22,
             "g2": 4.62
           }]
         },

         interactions: ['rotate', 'iteminfo'],

         //configure the legend.
         legend: {
           docked: 'bottom'
         },

         //describe the actual pie series.
         series: [{
           type: 'pie',
           xField: 'g1',
           animation: {
             easing: 'easeOut',
             duration: 500
           },
           label: {
             field: 'name',
             display: 'rotate'
           },
           donut: 25,
           style: {
             miterLimit: 10,
             lineCap: 'miter',
             strokeStyle: 'white',
             lineWidth: 1
           }
         }]
       }],
   buttons: [{
     text: 'submit',
     formBind: true,
     handler: function(btn) {
       var win = btn.up('window'),
         form = win.down('form');

       win.close();
     }
   }]
 }).show();