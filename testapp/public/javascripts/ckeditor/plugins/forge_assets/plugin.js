CKEDITOR.plugins.add('forge_assets', {
  init: function(editor) {
    var pluginName = 'forge_assets';
    editor.ui.addButton('ForgeAssets', {
      label: 'Add Images or Documents',
      click: function() { FORGE.assetDrawer.load(editor); },
      icon: '/javascripts/ckeditor/images/image_new.gif'
    });
  }
});