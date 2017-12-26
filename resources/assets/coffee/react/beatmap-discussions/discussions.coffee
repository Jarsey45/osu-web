###
#    Copyright 2015-2017 ppy Pty. Ltd.
#
#    This file is part of osu!web. osu!web is distributed with the hope of
#    attracting more community contributions to the core ecosystem of osu!.
#
#    osu!web is free software: you can redistribute it and/or modify
#    it under the terms of the Affero GNU General Public License version 3
#    as published by the Free Software Foundation.
#
#    osu!web is distributed WITHOUT ANY WARRANTY; without even the implied
#    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with osu!web.  If not, see <http://www.gnu.org/licenses/>.
###

{a, button, div, p, span} = ReactDOMFactories
el = React.createElement

bn = 'beatmap-discussions'
lp = 'beatmaps.discussions'

class BeatmapDiscussions.Discussions extends React.PureComponent
  constructor: (props) ->
    super props

    @state =
      sortField: 'created_at'


  render: =>
    discussions = @props.currentDiscussions[@props.mode]

    div className: 'osu-page osu-page--small osu-page--full',
      div
        className: bn

        div className: 'page-title',
          osu.trans('beatmaps.discussions.title')

        div className: "#{bn}__toolbar",
          div className: "#{bn}__toolbar-content #{bn}__toolbar-content--right",
            a
              href: '#'
              className: "#{bn}__toolbar-link"
              'data-type': 'sort'
              onClick: @changeSort
              span className: 'btn-osu-lite__right',
                if @state.sortField == 'updated_at'
                  osu.trans('beatmaps.discussions.collapse.sort-updated-time')
                else
                  osu.trans('beatmaps.discussions.collapse.sort-post-time')

            a
              href: '#'
              className: "#{bn}__toolbar-link"
              'data-type': 'collapse'
              onClick: @expand
              el IconExpand, expand: false
              span className: 'btn-osu-lite__right',
                osu.trans('beatmaps.discussions.collapse.all-collapse')

            a
              href: '#'
              className: "#{bn}__toolbar-link"
              'data-type': 'expand'
              onClick: @expand
              el IconExpand
              span className: 'btn-osu-lite__right',
                osu.trans('beatmaps.discussions.collapse.all-expand')


        if discussions.length == 0
          div className: "#{bn}__discussions #{bn}__discussions--empty",
            osu.trans 'beatmaps.discussions.empty.empty'

        else if _.size(@props.currentDiscussions.byFilter[@props.currentFilter][@props.mode]) == 0
          div className: "#{bn}__discussions #{bn}__discussions--empty",
            osu.trans 'beatmaps.discussions.empty.hidden'

        else
          div
            className: "#{bn}__discussions"
            @timelineCircle()

            if @props.mode == 'timeline'
              div className: "#{bn}__timeline-line hidden-xs"

            div null,
              @sortedDisussions().map @discussionPage

            @timelineCircle()


  discussionPage: (discussion) =>
    return if !discussion.id?

    className = "#{bn}__discussion"
    visible = @props.currentDiscussions.byFilter[@props.currentFilter][@props.mode][discussion.id]?
    className += ' u-hide-by-height' unless visible

    div
      key: discussion.id
      className: className
      el BeatmapDiscussions.Discussion,
        discussion: discussion
        users: @props.users
        currentUser: @props.currentUser
        beatmapset: @props.beatmapset
        currentBeatmap: @props.currentBeatmap
        userPermissions: @props.userPermissions
        readPostIds: @props.readPostIds
        visible: visible


  changeSort: (e) =>
    e.preventDefault()
    if @state.sortField == 'created_at'
      @setState sortField: 'updated_at'
    else
      @setState sortField: 'created_at'


  expand: (e) =>
    e.preventDefault()
    $.publish 'beatmapDiscussionEntry:collapse', collapse: e.currentTarget.dataset.type


  hidden: (discussion) =>
    switch @props.currentFilter
      when 'mine' then discussion.user_id != @props.currentUser.id
      when 'resolved' then discussion.message_type == 'praise' || !discussion.resolved
      when 'pending' then discussion.message_type == 'praise' || discussion.resolved
      when 'praises' then discussion.message_type != 'praise'
      else false


  sortedDisussions: ->
    discussions = @props.currentDiscussions[@props.mode]
    if @state.sortField == 'updated_at'
      discussions.sort (a, b) ->
        if Date.parse(a.updated_at) < Date.parse(b.updated_at) then 1 else -1
    else
      discussions.sort (a, b) ->
        if Date.parse(a.created_at) > Date.parse(b.created_at) then 1 else -1



  timelineCircle: =>
    div
      'data-visibility': if @props.mode != 'timeline' then 'hidden'
      className: "#{bn}__mode-circle #{bn}__mode-circle--active hidden-xs"
