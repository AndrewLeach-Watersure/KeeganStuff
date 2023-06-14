         '[extensibleFramework][tabName=U1][isTabView=true][userFunction=UUCHAN][name=u1_wspf_10_crf_indresource]': {
                focus: function() {
                                      EAM.Utils.debugMessage('Focus not blur');

                                         }                                                                                                                                     },


                                         Ext.define('EAM.custom.external_wsjobs', {
    extend: 'EAM.custom.AbstractExtensibleFramework',
    getSelectors: function() {
       return {
         '[extensibleFramework] [tabName=HDR][isTabView=true] [name=udfchar13]': {
                focus: function() {
                                      EAM.Utils.debugMessage('Focus not blur');

                                         }
                                                                                                                                       }
            }
        
    }
});

Ext.define('EAM.custom.external_wsjobs', {
    extend: 'EAM.custom.AbstractExtensibleFramework',
    getSelectors: function() {
       return {'[extensibleFramework] [tabName=U1][isTabView=true][userFunction=UUCHAN][name=u1_wspf_10_crf_indresource]': {
                focus: function() {
                                      EAM.Utils.debugMessage('Focus not blur');

                                         }                                                                                                                                     }
}
};



Ext.define('EAM.custom.external_wscrew', {
    extend: 'EAM.custom.AbstractExtensibleFramework',
    getSelectors: function() {
       return {
            '[extensibleFramework] [tabName=HDR] [name=organization]': {
                before_eam_customonblur: function(args) {
                    // args array is ['<event name>', <field object>, <last values object>]
                    var vField = args[1],
                        vLastValues = args[2];

                    if (vField.getValue() !== vLastValues[vField.name]) {
                        EAM.Utils.debugMessage('before_eam_customonblur');
                    }
                },
                customonblur: function(field, lastValues) {
                    if (field.getValue() !== lastValues[field.name]) {
                        EAM.Utils.debugMessage('customonblur');
                    }
                }
            },
            '[extensibleFramework] [tabName=HDR] [name=class]': {
                before_eam_customonblur: function(args) {
                    // args array is ['<event name>', <field object>, <last values object>]
                    var vField = args[1],
                        vLastValues = args[2];

                    if (vField.getValue() !== vLastValues[vField.name]) {
                        EAM.Utils.debugMessage('before_eam_customonblur');
                    }
                },
                customonblur: function(field, lastValues) {
                    if (field.getValue() !== lastValues[field.name]) {
                        EAM.Utils.debugMessage('customonblur');
                    }
                }
            },
            '[extensibleFramework] [tabName=HDR]': {
                before_eam_beforesaverecord: function() {
                    EAM.Utils.debugMessage('before_eam_beforesaverecord');
                },
                beforesaverecord: function() {
                    EAM.Utils.debugMessage('beforesaverecord');
                },

                before_eam_aftersaverecord: function() {
                    EAM.Utils.debugMessage('before_eam_aftersaverecord');
                },
                aftersaverecord: function() {
                    EAM.Utils.debugMessage('aftersaverecord');
                },

                before_eam_beforedestroyrecord: function() {
                    EAM.Utils.debugMessage('before_eam_beforedestroyrecord');
                },
                beforedestroyrecord: function() {
                    EAM.Utils.debugMessage('beforedestroyrecord');
                },

                before_eam_afterdestroyrecord: function() {
                    EAM.Utils.debugMessage('before_eam_afterdestroyrecord');
                },
                afterdestroyrecord: function() {
                    EAM.Utils.debugMessage('afterdestroyrecord');
                },

                before_eam_beforenewrecord: function() {
                    EAM.Utils.debugMessage('before_eam_beforenewrecord');
                },
                beforenewrecord: function() {
                    EAM.Utils.debugMessage('beforenewrecord');
                },

                before_eam_afternewrecord: function() {
                    EAM.Utils.debugMessage('before_eam_afternewrecord');
                },

                afternewrecord: function() {
                    EAM.Utils.debugMessage('afternewrecord');
                }
            },
            '[extensibleFramework] [tabName=EMP]': {
                before_eam_beforesaverecord: function() {
                    EAM.Utils.debugMessage('before_eam_beforesaverecord_tab');
                },
                beforesaverecord: function() {
                    EAM.Utils.debugMessage('beforesaverecord_tab');
                },

                before_eam_aftersaverecord: function() {
                    EAM.Utils.debugMessage('before_eam_aftersaverecord_tab');
                },
                aftersaverecord: function() {
                    EAM.Utils.debugMessage('aftersaverecord_tab');
                },

                before_eam_beforedestroyrecord: function() {
                    EAM.Utils.debugMessage('before_eam_beforedestroyrecord_tab');
                },
                beforedestroyrecord: function() {
                    EAM.Utils.debugMessage('beforedestroyrecord_tab');
                },

                before_eam_afterdestroyrecord: function() {
                    EAM.Utils.debugMessage('before_eam_afterdestroyrecord_tab');
                },
                afterdestroyrecord: function() {
                    EAM.Utils.debugMessage('afterdestroyrecord_tab');
                },

                before_eam_beforenewrecord: function() {
                    EAM.Utils.debugMessage('before_eam_beforenewrecord_tab');
                },
                beforenewrecord: function() {
                    EAM.Utils.debugMessage('beforenewrecord_tab');
                },

                before_eam_afternewrecord: function() {
                    EAM.Utils.debugMessage('before_eam_afternewrecord_tab');
                },
                afternewrecord: function() {
                    EAM.Utils.debugMessage('afternewrecord_tab');
                }
            }
        };
    }
});