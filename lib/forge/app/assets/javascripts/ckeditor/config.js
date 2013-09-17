/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  config.PreserveSessionOnFileBrowser = true;
  // Define changes to default configuration here. For example:
  config.language = 'en';

  config.height = '400px';

  // remove collapsible toolbars so that it fits on one line
  config.toolbarCanCollapse = false;

  // allow all content
  config.allowedContent = true;

  // works only with en, ru, uk languages
  config.extraPlugins = "mediaembed,forge_assets";
  config.removePlugins = 'iframe'; // otherwise, instead of a youtube video (for example) in the content, you get an iframe block

  config.toolbar = 'Basic';
  config.toolbar_Basic =
    [
      ['Bold','Italic','Underline','Strike','TextColor'],
      ['BulletedList', 'NumberedList', 'Blockquote'],
      ['Format','RemoveFormat'],
      ['Table','HorizontalRule'],
      ['Maximize'],
      ['PasteText', 'ForgeAssets','Link','Unlink','MediaEmbed'],
      ['Source']
    ];
};
