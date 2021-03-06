<%inherit file="/layouts/main.mako"/>
<%!
    from sickbeard.helpers import anon_url
    import sickbeard
%>
<%block name="metas">
<meta data-var="sickbeard.SORT_ARTICLE" data-content="${sickbeard.SORT_ARTICLE}">
</%block>
<%block name="content">
% if not header is UNDEFINED:
    <h1 class="header">${header}</h1>
% else:
    <h1 class="title">${title}</h1>
% endif
<div id="tabs">
    <span>Sort By:</span>
    <select id="showsort" class="form-control form-control-inline input-sm">
        <option value="name">Name</option>
        <option value="original" selected="selected">Original</option>
        <option value="votes">Votes</option>
        <option value="rating">% Rating</option>
        <option value="rating_votes">% Rating > Votes</option>
    </select>
    <span style="margin-left:12px;">Sort Order:</span>
    <select id="showsortdirection" class="form-control form-control-inline input-sm">
        <option value="asc" selected="selected">Asc</option>
        <option value="desc">Desc</option>
    </select>
</div>
<% imdb_tt = [show.imdbid for show in sickbeard.showList if show.imdbid] %>
<br />
<div id="popularShows">
    <div id="container">
% if not popular_shows:
        <div class="trakt_show" style="width:100%; margin-top:20px;">
            <p class="red-text">Fetching of IMDB Data failed. Are you online?
            <strong>Exception:</strong>
            <p>${imdb_exception}</p>
        </div>
% else:
    % for cur_result in popular_shows:
        % if cur_result['imdb_tt'] not in imdb_tt:
            <%
                cur_rating = float(cur_result.get('rating', 0))
                cur_votes = int(cur_result.get('votes', 0))
            %>
            <div class="trakt_show" data-name="${cur_result['name']}" data-rating="${cur_rating}" data-votes="${cur_votes}">
                <div class="traktContainer">
                    <div class="trakt-image">
                        <a class="trakt-image" href="${anon_url(cur_result['imdb_url'])}" target="_blank">
                            <img alt="" class="trakt-image" src="${srRoot}/cache/${cur_result['image_path']}" height="273px" width="186px" />
                        </a>
                    </div>
                    <div class="show-title">
                        ${cur_result['name'] or '<span>&nbsp;</span>'}
                    </div>
                    <div class="clearfix">
                        <p>${int(cur_rating*10)}% <img src="${srRoot}/images/heart.png"></p>
                        <i>${'{x} votes'.format(x=cur_votes) if cur_votes else '0 votes'}</i>
                        <div class="traktShowTitleIcons">
                            <a href="${srRoot}/addShows/addShowByID?indexer_id=${cur_result['imdb_tt']}&amp;show_name=${cur_result['name'] | u}&amp;indexer=IMDB" class="btn btn-xs" data-no-redirect>Add Show</a>
                        </div>
                    </div>
                </div>
            </div>
        % endif
    % endfor
% endif
    </div>
</div>
<br />
</%block>
