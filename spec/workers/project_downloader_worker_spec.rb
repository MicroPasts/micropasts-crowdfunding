require 'spec_helper'

describe ProjectDownloaderWorker do
  let(:project) { create(:project, video_url: nil) }
  let(:perform_project) { ProjectDownloaderWorker.perform_async(project.id) }

  before do
    Sidekiq::Testing.inline!

    project.video_url = 'http://vimeo.com/66698435'

    expect_any_instance_of(Project).to receive(:update_video_embed_url).and_call_original
    expect_any_instance_of(Project).to receive(:download_video_thumbnail)
  end

  it("should satisfy expectations") { perform_project }
end
