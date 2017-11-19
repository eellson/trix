#= require trix/views/attachment_view

{makeElement} = Trix

class Trix.ListenableAttachmentView extends Trix.AttachmentView
  constructor: ->
    super
    @attachment.previewDelegate = this

  createContentNodes: ->
    @audio = makeElement
      tagName: "audio"
      attributes:
        controls: "controls"
        src: ""
      data:
        trixMutable: true

    @refresh(@audio)
    [@audio]

  refresh: (audio) ->
    audio ?= @findElement()?.querySelector("audio")
    @updateAttributesForAudio(audio) if audio

  updateAttributesForAudio: (audio) ->
    url = @attachment.getURL()
    previewURL = @attachment.getPreviewURL()

    audio.src = previewURL or url

    if previewURL is url
      audio.removeAttribute("data-trix-serialized-attributes")
    else
      serializedAttributes = JSON.stringify(src: url)
      audio.setAttribute("data-trix-serialized-attributes", serializedAttributes)

    storeKey = ["audioElement", @attachment.id, audio.src].join("/")
    audio.dataset.trixStoreKey = storeKey

  # Attachment delegate

  attachmentDidChangeAttributes: ->
    @refresh(@audio)
    @refresh()
