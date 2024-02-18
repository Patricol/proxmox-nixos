{ novnc, esbuild, ... }:

novnc.overrideAttrs (_final: prev: {
  patches = prev.patches ++ [
    ./0001-add-PVE-specific-JS-code.patch
    ./0002-add-custom-fbresize-event-on-rfb.patch
    ./0003-change-scaling-when-toggling-fullscreen.patch
    ./0004-add-pve-style.patch
    ./0005-remove-vnc-logos.patch
    ./0006-change-source-directory-for-fetching-images-js-files.patch
    ./0007-add-pve-vnc-commands.patch
    ./0008-add-replaceable-snippets-in-vnc.html.patch
    ./0009-decrease-animation-time.patch
    ./0010-use-only-app.js.patch
    ./0011-add-localCursor-setting-to-rfb.patch
    ./0012-pass-custom-command-to-vnc.patch
    ./0013-Revert-Remove-the-default-value-of-wsProtocols.patch
    ./0014-avoid-passing-deprecated-upgrade-parameter.patch
    ./0015-create-own-class-for-hidden-buttons.patch
    ./0016-hide-fullscreen-button-on-isFullscreen-get-variable.patch
    ./0017-make-error-hideable.patch
    ./0018-show-start-button-on-not-running-vm-ct.patch
  ];
  buildInputs = [ esbuild ];
  installPhase = ''
    esbuild --bundle app/ui.js > app.js
  '' + prev.installPhase + ''
    cp app.js $out/share/webapps/novnc/
    mv $out/share/webapps/novnc/{vnc.html,index.html.tpl}
  '';

})

