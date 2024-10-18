# Transcribing talks

I wanted to get an LLM summary for
[XOXO Festival. Lisa Hanawalt, BoJack Horseman - XOXO Festival (2015)](https://www.youtube.com/watch?v=f6F_CF7Yvo0)
which turns out to be a perfect opportunity to test out transcribing audio using
[Whisper](https://en.wikipedia.org/wiki/Whisper_%28speech_recognition_system%29)!

Here is what I did to get a human readable transcript:

1. Download the video
   * `yt-dlp --extract-audio --audio-format mp3 'https://www.youtube.com/watch?v=f6F_CF7Yvo0' -o talk-audio.mp3`
2. Chunk into 10 minute chunks[^1]
   * `ffmpeg -i talk-audio.mp3  -f segment -segment_time 600 -c copy talk-audio-10m_chunks-%03d.mp3`
3. Transcribe the audio using Whisper through huggingface UI
   * Clickity click in https://huggingface.co/openai/whisper-large-v3 ,
     copy-pasting results into `transcript.txt`.
4. Chunk the text using Claude 3.5 Sonnet
   * `cat transcript.txt | llm -m claude-3.5-sonnet -s "Split the content of this transcript up into paragraphs with logical breaks. Add newlines between each paragraph." > transcript-chunked.txt`

This is already very useful!

Finishing touch:

`cat transcript-chunked.txt | llm -m claude-3.5-sonnet -s 'What are the themes in the given transcript of a talk?'`

I'm experimenting with using these kinds of summaries to make it both
easier to tremember but also easier to share with people.
Instead of sending someone a video with "Check out this talk, I think you will like it",
I can send a video with "Check out this talk, it is about $themes , I think you will like it".

## References

* Turning a Conference Talk into an Annotated Presentation - Jacob Kaplan-Moss.
  https://jacobian.org/til/talk-to-writeup-workflow/. Accessed 18 Oct. 2024.

## Tidbits

How do I "cite" a youtube video? American Psychological Association
[recommends](https://apastyle.apa.org/style-grammar-guidelines/references/examples/youtube-references)
a specific format, which I didn't want to type out by hand, so instead I investigated
`yt-dlp` a bit more:

`yt-dlp --skip-download --print "%(channel)s. (%(upload_date>%Y\\, %B %d)s). %(title)s [Video]. YouTube. %(webpage_url)s" 'https://www.youtube.com/watch?v=f6F_CF7Yvo0'`

[^1]: otherwise huggingface UI was failing with an error, I'm assuming a timeout.
