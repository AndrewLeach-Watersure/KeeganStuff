EAM.MsgBox.show({
msgs : [
{
type : 'warning',
msg : EAM.Lang.getCustomFrameworkMessage('My Custom Display Message')
}
],
buttons : EAM.MsgBox.YESNO,
itemId : 'MyMsgBox',
fn: Ext.bind(function(g, i, e) {
var a = this
, h = {};
if (e && e.fromScreenChange) {
h.skipFollowupActions = !0
}
if (g == 'yes') {
console.log('You clicked Yes button');
// You can write your custom logic here for Yes/Continue option
} else if (g == 'no') {
console.log('You clicked No button');
// You can write your custom logic here for No/Cancel option
}
Ext.ComponentQuery.query('eammsgbox button[itemId=yes]')[0].btnInnerEl.dom.innerHTML = 'Yes';
Ext.ComponentQuery.query('eammsgbox button[itemId=no]')[0].btnInnerEl.dom.innerHTML = 'No';

console.log(Ext.ComponentQuery.query('eammsgbox button[itemId=yes]')[0].btnInnerEl.dom.innerHTML);
console.log(Ext.ComponentQuery.query('eammsgbox button[itemId=no]')[0].btnInnerEl.dom.innerHTML);
}, null, [], !0)
}
);
Ext.ComponentQuery.query('eammsgbox button[itemId=yes]')[0].btnInnerEl.dom.innerHTML = 'Continue';
Ext.ComponentQuery.query('eammsgbox button[itemId=yes]')[0].btnWrap.dom.parentNode.style.left = "168px";
Ext.ComponentQuery.query('eammsgbox button[itemId=no]')[0].btnInnerEl.dom.innerHTML = 'Cancel';