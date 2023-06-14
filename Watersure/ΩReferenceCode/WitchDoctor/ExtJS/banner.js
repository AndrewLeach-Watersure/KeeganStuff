Ext.define('EAM.custom.external_wsjobs', {
    extend: 'EAM.custom.AbstractExtensibleFramework',
    getSelectors: function() {
        EAM.CUSTOMJS = EAM.CUSTOMJS || {};
        EAM.CUSTOMJS.applyCustomCSS = function(udfValue) {
            if (udfValue !== '1' && udfValue !== '2') {
                return;
            }

            var vRightText = '';

            if (udfValue === '1') {
                // background
                Ext.select('div.mhleft h2').applyStyles({
                    backgroundColor: '#ff0000', // red
                    paddingLeft: '5px',
                    paddingRight: '5px'
                });
                vRightText = '60 Days+ Overdue!';
            } else if (udfValue === '2') {
                // background
                Ext.select('div.mhleft h2').applyStyles({
                    backgroundColor: '#0000ff', // blue
                    paddingLeft: '5px',
                    paddingRight: '5px'
                });
                vRightText = 'Up to 60 Days Overdue!';
            }
            // header record text
            Ext.select('span.pagetitle').applyStyles({
                color: '#fff',
                fontWeight: 'bold'
            });
            Ext.select('span.recordcode').applyStyles({
                color: '#fff',
                fontWeight: 'bold'
            });
            Ext.select('span.recorddesc').applyStyles({
                color: '#fff',
                fontWeight: 'bold'
            });

            Ext.select('div.moduleheader_body div.mhleft h2')
               .insertHtml('beforeEnd', '<span class="extra" style="color: #fff; float: right; clear:both; font-size: 15px; font-weight: bold">' + vRightText + '</span>');
        };
        EAM.CUSTOMJS.getUdfValue = function() {
            EAM.CUSTOMJS.applyCustomCSS(EAM.Utils.getCurrentTab().getFldValue('udfchar30'));
        };

        return {
            '[extensibleFramework] uxform[tabName=HDR][isTabView=true]': {
                aftersaverecord: function() {
                    EAM.CUSTOMJS.getUdfValue();
                },
                afterrecordchange: function() {
                    EAM.CUSTOMJS.getUdfValue();
                },
                afterloaddata: function() {
                    EAM.CUSTOMJS.getUdfValue();
                }
            },
            '[extensibleFramework] listview readonlygrid': {
                // some grids allow you to select multiple records
                // this always examines the last selected record
                // NOTE: the UDF field you are care about MUST be visible in the
                //       grid or this will be unable to fetch the value
                select: function(selectionModel, recordSelected) {
                    EAM.CUSTOMJS.applyCustomCSS(recordSelected.get('udfchar30'));
                }
            }
        };
    }
});







grid MUBNNR
alert

10085
10091
10094

26304



