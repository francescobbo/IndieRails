require_relative '../../app/lib/webmention_client'

describe WebmentionClient do
  describe '#deliver' do
    it 'discovers the webmention endpoint for the target' do
      expect(subject).to receive(:discover) { URI.parse('https://wm.rocks/endpoint') }

      stub_request(:any, "https://wm.rocks/endpoint")

      subject.deliver('me', 'there')
    end

    context 'when a webmention endpoint is found' do
      it 'sends a webmention request' do
        allow(subject).to receive(:discover) { URI.parse('https://wm.rocks/endpoint') }

        request = stub_request(:post, "https://wm.rocks/endpoint").with(body: { source: 'me', target: 'there' })

        subject.deliver('me', 'there')

        expect(request).to have_been_requested
      end
    end
  end

  describe '#discover' do
    test_pages = [
      {
        url: 'https://webmention.rocks/test/1',
        endpoint: 'https://webmention.rocks/test/1/webmention?head=true'
      },
      {
        url: 'https://webmention.rocks/test/2',
        endpoint: 'https://webmention.rocks/test/2/webmention?head=true'
      },
      {
        url: 'https://webmention.rocks/test/3',
        endpoint: 'https://webmention.rocks/test/3/webmention'
      },
      {
        url: 'https://webmention.rocks/test/4',
        endpoint: 'https://webmention.rocks/test/4/webmention'
      },
      {
        url: 'https://webmention.rocks/test/5',
        endpoint: 'https://webmention.rocks/test/5/webmention'
      },
      {
        url: 'https://webmention.rocks/test/6',
        endpoint: 'https://webmention.rocks/test/6/webmention'
      },
      {
        url: 'https://webmention.rocks/test/7',
        endpoint: 'https://webmention.rocks/test/7/webmention?head=true'
      },
      {
        url: 'https://webmention.rocks/test/8',
        endpoint: 'https://webmention.rocks/test/8/webmention?head=true'
      },
      {
        url: 'https://webmention.rocks/test/9',
        endpoint: 'https://webmention.rocks/test/9/webmention'
      },
      {
        url: 'https://webmention.rocks/test/10',
        endpoint: 'https://webmention.rocks/test/10/webmention?head=true'
      },
      {
        url: 'https://webmention.rocks/test/11',
        endpoint: 'https://webmention.rocks/test/11/webmention'
      },
      {
        url: 'https://webmention.rocks/test/12',
        endpoint: 'https://webmention.rocks/test/12/webmention'
      },
      {
        url: 'https://webmention.rocks/test/13',
        endpoint: 'https://webmention.rocks/test/13/webmention'
      },
      {
        url: 'https://webmention.rocks/test/14',
        endpoint: 'https://webmention.rocks/test/14/webmention'
      },
      {
        url: 'https://webmention.rocks/test/15',
        endpoint: 'https://webmention.rocks/test/15'
      },
      {
        url: 'https://webmention.rocks/test/16',
        endpoint: 'https://webmention.rocks/test/16/webmention'
      },
      {
        url: 'https://webmention.rocks/test/17',
        endpoint: 'https://webmention.rocks/test/17/webmention'
      },
      {
        url: 'https://webmention.rocks/test/18',
        endpoint: 'https://webmention.rocks/test/18/webmention?head=true'
      },
      {
        url: 'https://webmention.rocks/test/19',
        endpoint: 'https://webmention.rocks/test/19/webmention?head=true'
      },
      {
        url: 'https://webmention.rocks/test/20',
        endpoint: 'https://webmention.rocks/test/20/webmention'
      },
      {
        url: 'https://webmention.rocks/test/21',
        endpoint: 'https://webmention.rocks/test/21/webmention?query=yes'
      },
      {
        url: 'https://webmention.rocks/test/22',
        endpoint: 'https://webmention.rocks/test/22/webmention'
      },
      {
        url: 'https://webmention.rocks/test/23/page',
        endpoint: 'https://webmention.rocks/test/23/page/webmention-endpoint/gFn0wqlGgKSL76Es8VHV'
      }
    ]

    test_pages.each_with_index do |test, n|
      it "Passes Webmention.rocks test ##{n + 1}" do
        VCR.use_cassette("webmention-rocks/#{n + 1}") do
          endpoint = subject.discover(test[:url]).to_s
          expect(endpoint).to eq test[:endpoint]
        end
      end
    end
  end
end
