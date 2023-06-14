Ext.create('Ext.window.Window', {
   extend: 'Ext.Container',
   title: 'Grid Test',
   autoShow: true,
   height: 700,
   width: 1000,
   scrollable: 'true',
   bodyPadding: 10,
   maximizable: true,
   bodyStyle: 'background-color:#F0F0F0;padding: 10px',
   items: [{
     xtype: 'grid',
     renderTo: document.body,
     multiColumnSort: true,
     width: 1000,
     height: 600,
     store: EAM.Ajax.request({
url: "GRIDDATA",
params: {
GRID_NAME: "XU5BOO",
REQUEST_TYPE: "LIST.HEAD_DATA.STORED"
},
async: false,
method: "POST"
}).responseData.pageData.grid.GRIDRESULT.GRID.DATA,
     columns: [
     {
         text: 'Date Entered',
         dataIndex: 'boo_entered',
         flex: 1
       },
       {
         text: 'Date',
         dataIndex: 'boo_date',
         flex: 1
       },
       {
         text: 'Employee',
         dataIndex: 'boo_person',
         flex: 1
       },
       {
         text: 'Work Order',
         dataIndex: 'boo_event',
         flex: 1
       },
       {
         text: 'Act',
         dataIndex: 'boo_act',
         flex: 1
       },
       {
         text: 'WO Desc',
         dataIndex: 'evt_desc',
         flex: 1
       },
       {
         text: 'Descriptions',
         dataIndex: 'boo_desc',
         flex: 1
       },
       {
         text: 'Hours',
         dataIndex: 'boo_hours',
         flex: 1
       }
     ]
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
