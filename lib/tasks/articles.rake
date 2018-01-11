# frozen_string_literal: true

namespace :articles do
  desc "Populate initial set of MyApnea articles."
  task populate: :environment do
    faqs = Admin::Category.where(slug: "faqs").first_or_create(name: "FAQs")
    Broadcast.where(slug: "what-is-myapnea-org").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "What is MyApnea.Org?",
      description: "MyApnea.Org is a network created by people with sleep apnea to empower others like us to get the answers we want and need through sharing and promoting research. MyApnea.Org offers sleep apnea patients and caregivers the opportunity to LEARN more about apnea and effective treatments, SHARE experiences with other members of the community, and contribute to RESEARCH to improve diagnosis, management, and treatments for sleep apnea.\n\nMyApnea.Org is what’s called patient-powered research. You and others within the sleep apnea community can share health information, discuss experiences regarding treatment, and express views directly to researchers and sleep experts on future research projects that can make a difference. In return, you will get easy-to-use tools to track your health and learn from others about treatments, symptoms, and coping with sleep apnea to take control of your life."
    )

    Broadcast.where(slug: "how-is-myapnea-org-organized").first_or_create(
      user: User.first,
      category: faqs,
      published: true,
      publish_date: Time.zone.today,
      title: "How is MyApnea.Org organized?",
      description: "There are three main sections of MyApnea.Org. One section has information and resources about sleep apnea to help you LEARN more about the disorder and how best to manage symptoms. Another section offers different ways for you to connect and SHARE with others within the MyApnea.Org community. The third section is a RESEARCH portal, which allows consenting members to participate in research with the aim of improving sleep apnea care and treatments. To accomplish this research, you will be asked to take easy-to-complete surveys and to join other study activities. As we post new surveys, we'll invite you to complete them, too. You’ll also receive special invitations (at least twice per year) to participate in other parts of the study. We will only ask for your participation in such a study after you've consented to that specific study. You will see all of your study activities and special invitations on your \"dashboard\" once you join the study."
    )
  end
end
