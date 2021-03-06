<%!
    import datetime
    import re
    import sickbeard
    from sickrage.helper.common import pretty_file_size
    from sickrage.show.Show import Show
    from time import time
%>
<!-- BEGIN HEADER -->
<nav class="navbar navbar-default navbar-fixed-top hidden-print" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#main_nav">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="${srRoot}/home/" title="SickRage"><img alt="SickRage" src="${srRoot}/images/medusa.png" style="height: 50px;" class="img-responsive pull-left" /></a>
        </div>
    % if loggedIn:
        <div class="collapse navbar-collapse" id="main_nav">
            <ul class="nav navbar-nav navbar-right">
                <li id="NAVhome" class="navbar-split dropdown${' active' if topmenu == 'home' else ''}">
                    <a href="${srRoot}/home/" class="dropdown-toggle" aria-haspopup="true" data-toggle="dropdown" data-hover="dropdown"><span>Shows</span>
                    <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="${srRoot}/home/"><i class="menu-icon-home"></i>&nbsp;Show List</a></li>
                        <li><a href="${srRoot}/addShows/"><i class="menu-icon-addshow"></i>&nbsp;Add Shows</a></li>
                        <li><a href="${srRoot}/home/postprocess/"><i class="menu-icon-postprocess"></i>&nbsp;Manual Post-Processing</a></li>
                        % if sickbeard.SHOWS_RECENT:
                            <li role="separator" class="divider"></li>
                            % for recentShow in sickbeard.SHOWS_RECENT:
                                <li><a href="${srRoot}/home/displayShow?show=${recentShow['indexerid']}"><i class="menu-icon-addshow"></i>&nbsp;${recentShow['name']|trim,h}</a></li>
                            % endfor
                        % endif
                    </ul>
                    <div style="clear:both;"></div>
                </li>
                <li id="NAVschedule"${' class="active"' if topmenu == 'schedule' else ''}>
                    <a href="${srRoot}/schedule/">Schedule</a>
                </li>
                <li id="NAVhistory"${' class="active"' if topmenu == 'history' else ''}>
                    <a href="${srRoot}/history/">History</a>
                </li>
                <li id="NAVmanage" class="navbar-split dropdown${' active' if topmenu == 'manage' else ''}">
                    <a href="${srRoot}/manage/episodeStatuses/" class="dropdown-toggle" aria-haspopup="true" data-toggle="dropdown" data-hover="dropdown"><span>Manage</span>
                    <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="${srRoot}/manage/"><i class="menu-icon-manage"></i>&nbsp;Mass Update</a></li>
                        <li><a href="${srRoot}/manage/backlogOverview/"><i class="menu-icon-backlog-view"></i>&nbsp;Backlog Overview</a></li>
                        <li><a href="${srRoot}/manage/manageSearches/"><i class="menu-icon-manage-searches"></i>&nbsp;Manage Searches</a></li>
                        <li><a href="${srRoot}/manage/episodeStatuses/"><i class="menu-icon-manage2"></i>&nbsp;Episode Status Management</a></li>
                    % if sickbeard.USE_PLEX_SERVER and sickbeard.PLEX_SERVER_HOST != "":
                        <li><a href="${srRoot}/home/updatePLEX/"><i class="menu-icon-plex"></i>&nbsp;Update PLEX</a></li>
                    % endif
                    % if sickbeard.USE_KODI and sickbeard.KODI_HOST != "":
                        <li><a href="${srRoot}/home/updateKODI/"><i class="menu-icon-kodi"></i>&nbsp;Update KODI</a></li>
                    % endif
                    % if sickbeard.USE_EMBY and sickbeard.EMBY_HOST != "" and sickbeard.EMBY_APIKEY != "":
                        <li><a href="${srRoot}/home/updateEMBY/"><i class="menu-icon-emby"></i>&nbsp;Update Emby</a></li>
                    % endif
                    % if sickbeard.USE_TORRENTS and sickbeard.TORRENT_METHOD != 'blackhole' and (sickbeard.ENABLE_HTTPS and sickbeard.TORRENT_HOST[:5] == 'https' or not sickbeard.ENABLE_HTTPS and sickbeard.TORRENT_HOST[:5] == 'http:'):
                        <li><a href="${srRoot}/manage/manageTorrents/"><i class="menu-icon-bittorrent"></i>&nbsp;Manage Torrents</a></li>
                    % endif
                    % if sickbeard.USE_FAILED_DOWNLOADS:
                        <li><a href="${srRoot}/manage/failedDownloads/"><i class="menu-icon-failed-download"></i>&nbsp;Failed Downloads</a></li>
                    % endif
                    % if sickbeard.USE_SUBTITLES:
                        <li><a href="${srRoot}/manage/subtitleMissed/"><i class="menu-icon-backlog"></i>&nbsp;Missed Subtitle Management</a></li>
                    % endif
                    </ul>
                    <div style="clear:both;"></div>
                </li>
                <li id="NAVconfig" class="navbar-split dropdown${' active' if topmenu == 'config' else ''}">
                    <a href="${srRoot}/config/" class="dropdown-toggle" aria-haspopup="true" data-toggle="dropdown" data-hover="dropdown"><span class="visible-xs-inline">Config</span><img src="${srRoot}/images/menu/system18.png" class="navbaricon hidden-xs" />
                    <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="${srRoot}/config/"><i class="menu-icon-help"></i>&nbsp;Help &amp; Info</a></li>
                        <li><a href="${srRoot}/config/general/"><i class="menu-icon-config"></i>&nbsp;General</a></li>
                        <li><a href="${srRoot}/config/backuprestore/"><i class="menu-icon-backup"></i>&nbsp;Backup &amp; Restore</a></li>
                        <li><a href="${srRoot}/config/search/"><i class="menu-icon-manage-searches"></i>&nbsp;Search Settings</a></li>
                        <li><a href="${srRoot}/config/providers/"><i class="menu-icon-provider"></i>&nbsp;Search Providers</a></li>
                        <li><a href="${srRoot}/config/subtitles/"><i class="menu-icon-backlog"></i>&nbsp;Subtitles Settings</a></li>
                        <li><a href="${srRoot}/config/postProcessing/"><i class="menu-icon-postprocess"></i>&nbsp;Post Processing</a></li>
                        <li><a href="${srRoot}/config/notifications/"><i class="menu-icon-notification"></i>&nbsp;Notifications</a></li>
                        <li><a href="${srRoot}/config/anime/"><i class="menu-icon-anime"></i>&nbsp;Anime</a></li>
                    </ul>
                    <div style="clear:both;"></div>
                </li>
                <li id="NAVsystem" class="navbar-split dropdown${' active' if topmenu == 'system' else ''}">
                    <a href="${srRoot}/home/status/" class="dropdown-toggle" aria-haspopup="true" data-toggle="dropdown" data-hover="dropdown"><span class="visible-xs-inline">Tools</span><img src="${srRoot}/images/menu/system18-2.png" class="navbaricon hidden-xs" />${toolsBadge}
                    <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a href="${srRoot}/news/"><i class="menu-icon-news"></i>&nbsp;News${newsBadge}</a></li>
                        <li><a href="${srRoot}/IRC/"><i class="menu-icon-irc"></i>&nbsp;IRC</a></li>
                        <li><a href="${srRoot}/changes/"><i class="menu-icon-changelog"></i>&nbsp;Changelog</a></li>
                        <li><a href="https://github.com/PyMedusa/SickRage/wiki/Donations" rel="noreferrer" onclick="window.open('${sickbeard.ANON_REDIRECT}' + this.href); return false;"><i class="menu-icon-support"></i>&nbsp;Support Medusa</a></li>
                        <li role="separator" class="divider"></li>
                        %if numErrors:
                            <li><a href="${srRoot}/errorlogs/"><i class="menu-icon-error"></i>&nbsp;View Errors <span class="badge btn-danger">${numErrors}</span></a></li>
                        %endif
                        %if numWarnings:
                            <li><a href="${srRoot}/errorlogs/?level=${sickbeard.logger.WARNING}"><i class="menu-icon-viewlog-errors"></i>&nbsp;View Warnings <span class="badge btn-warning">${numWarnings}</span></a></li>
                        %endif
                        <li><a href="${srRoot}/errorlogs/viewlog/"><i class="menu-icon-viewlog"></i>&nbsp;View Log</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="${srRoot}/home/updateCheck?pid=${sbPID}"><i class="menu-icon-update"></i>&nbsp;Check For Updates</a></li>
                        <li><a href="${srRoot}/home/restart/?pid=${sbPID}" class="confirm restart"><i class="menu-icon-restart"></i>&nbsp;Restart</a></li>
                        <li><a href="${srRoot}/home/shutdown/?pid=${sbPID}" class="confirm shutdown"><i class="menu-icon-shutdown"></i>&nbsp;Shutdown</a></li>
                        % if loggedIn is not True:
                            <li><a href="${srRoot}/logout" class="confirm logout"><i class="menu-icon-shutdown"></i>&nbsp;Logout</a></li>
                        % endif
                        <li role="separator" class="divider"></li>
                        <li><a href="${srRoot}/home/status/"><i class="menu-icon-info"></i>&nbsp;Server Status</a></li>
                    </ul>
                    <div style="clear:both;"></div>
                </li>
            </ul>
    % endif
        </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
</nav>
<!-- END HEADER -->
