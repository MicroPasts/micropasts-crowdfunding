require 'spec_helper'

describe Project::VideoHandler do
  let(:project) { create(:project) }

  describe "#download_video_thumbnail" do
    before do
      expect(project).to receive(:download_video_thumbnail).and_call_original
      expect(project).to receive(:open).and_return(File.open("#{Rails.root}/spec/fixtures/image.png"))

      project.download_video_thumbnail
    end

    it "should open the video_url and store it in video_thumbnail" do
      expect(project.video_thumbnail.url).to eq("/uploads/project/video_thumbnail/#{project.id}/image.png")
    end
  end

  describe "#update_video_embed_url" do
    before do
      project.video_url = 'http://vimeo.com/49584778'
      expect(project.video).to receive(:embed_url).and_call_original
      project.update_video_embed_url
    end

    it "should store the new embed url" do
      expect(project.video_embed_url).to eq('player.vimeo.com/video/49584778')
    end
  end

  describe "#video" do
    subject { project }

    context "video_url is blank" do
      before { project.video_url = ''}

      describe '#video' do
        subject { super().video }
        it { should be_nil}
      end
    end

    context 'video_url is defined' do
      before { project.video_url = "http://vimeo.com/17298435" }

      context 'video_url is a Vimeo url' do
        describe '#video' do
          subject { super().video }
          it { should be_an_instance_of(VideoInfo) }
        end
      end

      context 'video_url is an YouTube url' do
        before { project.video_url = "http://www.youtube.com/watch?v=Brw7bzU_t4c" }

        describe '#video' do
          subject { super().video }
          it { should be_an_instance_of(VideoInfo) }
        end
      end

      it 'caches the response object' do
        video_obj = VideoInfo.get(project.video_url)
        expect(VideoInfo).to receive(:get).once.and_return(video_obj)
        5.times { project.video }
      end
    end
  end

end
