{ config, lib, pkgs, ... }:

with lib; 
let
  cfg = config.modules.browser.firefox;
in 
{
  options.modules.browser.firefox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles.default = {
        id = 0;
        name = "Default";
        settings = {

          /*  INDEX
              
              0100: STARTUP
              0200: GEOLOCATION / LANGUAGE / LOCALE
              0300: QUIETER FOX
              0400: SAFE BROWSING
              0800: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS 
              0900: PASSWORDS
              1200: HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
              1700: CONTAINERS
              2600: DOWNLOADS
              2700: ETP (ENHANCED TRACKING PROTECTION)
              2800: SHUTDOWN & SANITIZING
              5000: OPTIONAL OPSEC
              9000: PERSONAL

          /* 0000: disable about:config warning */
          "browser.aboutConfig.showWarning" = false; 

          ### [SECTION 0100]: STARTUP ###
          /* 0101: disable default browser check */
          "browser.shell.checkDefaultBrowser" = false;

          /* 0102: set startup page [SETUP-CHROME]
             0=blank, 1=home, 2=last visited page, 3=resume previous session
          */
          "browser.startup.page" = 0;

          /* 0103: set HOME+NEWWINDOW page */
          "browser.startup.homepage" = "about:blank";

          /* 0104: set NEWTAB page
             true=Activity Stream (default, see 0105), false=blank page
             [SETTING] Home>New Windows and Tabs>New tabs
          */
          "browser.newtabpage.enabled" = false;
          "browser.newtab.preload"     = false;

          /* 0105: disable some Activity Stream items
             Activity Stream is the default homepage/newtab based on metadata 
             and browsing behavior.
          */
          "browser.newtabpage.activity-stream.feeds.telemetry"                  = false;
          "browser.newtabpage.activity-stream.telemetry"                        = false;
          "browser.newtabpage.activity-stream.feeds.snippets"                   = false; 
          "browser.newtabpage.activity-stream.feeds.section.topstories"         = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored"                    = false;
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed"        = false; 
          "browser.newtabpage.activity-stream.showSponsoredTopSites"            = false; 

          /* 0106: clear default top sites */
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.urlbar.suggest.topsites" = false;

          ### [SECTION 0300]: QUIETER FIREFOX ###
          /* 0320: disable recommendation pane in about:addons (uses Google Analytics) */
          "extensions.getAddons.showPane" = false;
          
          /* 0321: disable recommendations in about:addons */
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          /* 0330: disable new data submission */
          "datareporting.policy.dataSubmissionEnabled" = false;

          /* 0331: disable health reports */
          "datareporting.healthreport.uploadEnabled" = false;

          /* 0332: disable telemetry */
          "toolkit.telemetry.unified"                    = false;
          "toolkit.telemetry.enabled"                    = false;
          "toolkit.telemetry.server"                     = "data:,";
          "toolkit.telemetry.archive.enabled"            = false;
          "toolkit.telemetry.newProfilePing.enabled"     = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled"         = false;
          "toolkit.telemetry.bhrPing.enabled"            = false;
          "toolkit.telemetry.firstShutdownPing.enabled"  = false;

          /* 0333: disable telemetry coverage 
             [1] https://blog.mozilla.org/data/2018/08/20/effectively-measuring-search-in-firefox/
          */
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.opt-out"           = true;
          "toolkit.coverage.endpoint.base"     = "";

          ### [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ###
          /* 0802: disable location bar domain guessing 
             domain guessing intercepts DNS "hostname not found errors" and resends a
             request (e.g. by adding www or .com). This is inconsistent use (e.g. FQDNs), does not work
             via Proxy Servers (different error), is a flawed use of DNS (TLDs: why treat .com
             as the 411 for DNS errors?), privacy issues (why connect to sites you didn't
             intend to), can leak sensitive data (e.g. query strings: e.g. Princeton attack)
          */
          "browser.fixup.alternate.enabled" = false;

          /* 0803: display all parts of the url in the location bar */
          "browser.urlbar.trimURLs" = false;
          
          /* 0805: disable location bar making speculative connections */
          "browser.urlbar.speculativeConnect.enabled" = false;

          /* 0807: disable location bar contextual suggestions [FF92+]
             [1] https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/
          */
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored"    = false;

          /* 0810: disable search and form history */
          "browser.formfill.enable" = false;

          /* 0811: disable form autofill */
          "extensions.formautofill.addresses.enabled"     = false; 
          "extensions.formautofill.available"             = "off"; 
          "extensions.formautofill.creditCards.available" = false; 
          "extensions.formautofill.creditCards.enabled"   = false; 
          "extensions.formautofill.heuristics.enabled"    = false; 

          ### [SECTION 0900]: PASSWORD ###

          /* 0903: disable auto-filling username & password form fields
             can leak in cross-site forms *and* be spoofed
             [NOTE] Username & password is still available when you enter the field
             [SETTING] Privacy & Security>Logins and Passwords>Autofill logins and passwords
             [1] https://freedom-to-tinker.com/2017/12/27/no-boundaries-for-user-identities-web-trackers-exploit-browser-login-managers/
          */
          "signon.autofillForms" = false;

          /* 0904: disable formless login capture for Password Manager */
          "signon.formlessCapture.enabled" = false;

          /* 0905: limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources
             hardens against potential credentials phishing
             0 = don't allow sub-resources to open HTTP authentication credentials dialogs
             1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
             2 = allow sub-resources to open HTTP authentication credentials dialogs (default)
          */
          "network.auth.subresource-http-auth-allow" = 1;

          ### [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP) ###
          /* 1244: enable HTTPS-Only mode in all windows */
          "dom.security.https_only_mode" = true;

          /* 1272: display advanced information on Insecure Connection warning pages */
          "browser.xul.error_pages.expert_bad_cert" = true;

          ### [SECTION 1700]: CONTAINERS ###
          /* 1701: enable Container Tabs and its UI setting */
          "privacy.userContext.enabled"    = true;
          "privacy.userContext.ui.enabled" = true;

          ### [SECTION 2600]: DOWNLOADS ###
          /* 2651: enable user interaction for security by always asking where to download
             [SETTING] General>Downloads>Always ask you where to save files
          */
          "browser.download.useDownloadDir" = false;

          /* 2652: disable downloads panel opening on every download */
          "browser.download.alwaysOpenPanel" = false;

          /* 2653: disable adding downloads to the system's "recent documents" list */
          "browser.download.manager.addToRecentDocs" = false;

          ### [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ###
          /* 2701: enable ETP Strict Mode [FF86+]
             ETP Strict Mode enables Total Cookie Protection (TCP)
          */
          "browser.contentblocking.category" = "strict";

          /* 2710: enable state partitioning of service workers */
          "privacy.partition.serviceWorkers" = true;

          ### [SECTION 2800]: SHUTDOWN & SANITIZING ###
          /* 2801: delete cookies and site data on exit 
             0=keep until they expire (default), 2=keep until you close Firefox
          */
          "network.cookie.lifetimePolicy" = 2;

          /* 2803: set third-party cookies to session-only
             [1] https://feeding.cloud.geek.nz/posts/tweaking-cookies-for-privacy-in-firefox/
          */
          "network.cookie.thirdparty.sessionOnly" = true;
          "network.cookie.thirdparty.nonsecureSessionOnly" = true;

          /* 2810: enable Firefox to clear items on shutdown */
          "privacy.sanitize.sanitizeOnShutdown" = true;

          /* 2811: set/enforce what items to clear on shutdown (if 2810 is true) */
          "privacy.clearOnShutdown.cache"       = true;
          "privacy.clearOnShutdown.downloads"   = true; 
          "privacy.clearOnShutdown.formdata"    = true;
          "privacy.clearOnShutdown.history"     = true;
          "privacy.clearOnShutdown.sessions"    = true;
          "privacy.clearOnShutdown.offlineApps" = false;
          "privacy.clearOnShutdown.cookies"     = false;

          ### [SECTION 5000]: OPTIONAL OPSEC ###
          /* 5003: don't ask to save logins and passwords */
          "signon.rememberSignons" = false;

          ### [SECTION 9000]: PERSONAL ###
          /* UPDATES */
          "app.update.auto" = false;

          /* UX FEATURES */
          "extensions.pocket.enabled"   = false;
          "identity.fxaccounts.enabled" = false;
        };
      };
    };
  };
}
