import 'package:news_zen/core/model/news_model.dart';


List<NewsModel> mockNewsData = [
  NewsModel(
    title: 'Breaking: World Leaders Meet in Geneva for Peace Talks',
    imageurl: 'https://i.guim.co.uk/img/media/c722e117dd8823bbf7155423383240bfad343839/0_131_3442_2065/master/3442.jpg?width=620&dpr=2&s=none&crop=none',
    source: 'BBC',
    description: 'In a historic moment, world leaders have converged in Geneva to participate in groundbreaking peace talks aimed at addressing ongoing geopolitical tensions. The summit, which brings together heads of state from various nations, represents a last-ditch effort to resolve multiple international conflicts diplomatically. Key issues on the agenda include the escalating situation in Eastern Europe, trade disputes in Asia, and regional conflicts in the Middle East. The Geneva summit is viewed as a rare opportunity to de-escalate tensions that have been building for months, threatening global stability. Experts believe that the outcome of these discussions could shape the future of international relations for years to come. Negotiations are expected to be intense, with both sides facing pressure from their respective governments and citizens. While there is cautious optimism surrounding the talks, concerns remain that the deeply entrenched differences may be too great to overcome in such a short timeframe. Nevertheless, the fact that these leaders have agreed to meet at all is being hailed as a diplomatic victory. The world waits anxiously to see if this summit will mark a turning point in efforts to maintain global peace and security.',
    url: 'https://www.bbc.com/news/world-asia-65657996',
    dateTime: DateTime.parse('2024-10-15T10:00:00Z'), // Example date and time
    topic: 'World',
    language: 'en',
    likecount: 10,
    priority: 10, id: ''
  ),
  NewsModel(
    title: 'Tech Stocks Soar as Markets Recover from Last Week’s Slump',
    imageurl: 'https://ichef.bbci.co.uk/news/1536/cpsprodpb/6f82/live/ce1422c0-2da3-11ef-9d79-b966227f8b9b.jpg.webp',
    source: 'CNN',
    description: 'After a volatile week on Wall Street, tech stocks have rebounded sharply, driving a broader market recovery that has analysts breathing a sigh of relief. Leading the charge are major technology companies, whose strong earnings reports have buoyed investor confidence. This comes after a significant slump last week that saw markets lose billions in value due to fears of inflation and rising interest rates. However, the latest earnings season has provided much-needed reassurance, with key players like Apple, Google, and Microsoft exceeding expectations. The recovery has also been fueled by optimism over new product launches, including next-generation smartphones, cloud computing services, and AI-driven software. Market experts suggest that the tech sector\'s resilience could help sustain the broader market recovery in the coming months. However, there are still some concerns about the long-term impact of global economic challenges, including supply chain disruptions and geopolitical tensions. Investors are cautiously optimistic, but the focus now shifts to how well these companies can maintain their momentum in the face of ongoing uncertainties.',
    url: 'https://www.cnn.com/2024/10/market-recovery-tech',
    dateTime: DateTime.parse('2024-10-14T12:30:00Z'), // Example date and time
    topic: 'Business',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'NASA Announces New Mission to Mars: Details Inside',
    imageurl: 'https://media.cnn.com/api/v1/images/stellar/prod/200713065020-emirates-mars-3.jpg?q=w_1110,c_fill/f_webp',
    source: 'Al Jazeera',
    description: 'NASA has unveiled plans for its most ambitious Mars mission yet, set to launch in 2026. The mission, which aims to delve deeper into the planet’s geological history, will focus on searching for signs of ancient life. This groundbreaking exploration will involve sending a new generation of rovers and orbital spacecraft to gather and analyze samples from key Martian regions that scientists believe once held water. The mission is part of NASA\'s long-term strategy to eventually send humans to Mars, building on the success of previous missions, including Perseverance and Curiosity. In addition to studying the planet\'s past habitability, the mission will also test new technologies that could one day support human life on the Red Planet, such as advanced life support systems and habitat modules. The excitement surrounding this mission is palpable, as it promises to bring humanity one step closer to unlocking the mysteries of Mars and potentially paving the way for future colonization efforts. Space enthusiasts and scientists alike are eager to see what discoveries await as NASA continues to push the boundaries of space exploration.',
    url: 'https://www.aljazeera.com/nasa-mission-to-mars-2026',
    dateTime: DateTime.parse('2024-10-13T08:00:00Z'), // Example date and time
    topic: 'Science',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'Global Climate Action: Countries Commit to Reducing Emissions',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jpwpvf.jpg.webp',
    source: 'The Guardian',
    description: 'In a major step towards combating climate change, over 150 countries have signed a new international agreement committing to significant reductions in greenhouse gas emissions by the year 2030. The agreement, which was reached after intense negotiations, outlines specific targets for reducing carbon emissions, transitioning to renewable energy sources, and protecting ecosystems. While environmental groups are cautiously optimistic about the potential impact of this deal, there are concerns about the enforceability of the commitments and whether all nations will follow through. The agreement places particular emphasis on helping developing countries transition to cleaner energy without sacrificing economic growth, a key sticking point during the talks. Leaders from around the world have hailed the deal as a turning point in global climate policy, but many acknowledge that much work remains to be done. The next decade will be critical in determining whether these ambitious targets can be met, and whether they will be enough to avoid the worst effects of climate change. The agreement also includes mechanisms for tracking progress, with regular updates planned to ensure accountability.',
    url: 'https://www.theguardian.com/environment/global-climate-action-commitment',
    dateTime: DateTime.parse('2024-10-12T09:15:00Z'), // Example date and time
    topic: 'Environment',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'AI Revolution: How Artificial Intelligence is Shaping the Future',
    imageurl: 'https://media.cnn.com/api/v1/images/stellar/prod/231130081825-sam-altman-1116.jpg?c=original',
    source: 'TechCrunch',
    description: 'Artificial intelligence (AI) is transforming industries across the globe at an unprecedented pace. From healthcare to finance, AI-driven solutions are revolutionizing the way we live and work. This article delves into the latest advancements in AI technology, highlighting key developments that are shaping the future. In healthcare, AI is being used to diagnose diseases earlier, enhance treatment plans, and even assist in surgeries, leading to improved patient outcomes. In finance, AI algorithms are revolutionizing how markets are analyzed, enabling faster, more accurate predictions and investment strategies. But it’s not just these industries that are benefiting; AI is also making significant strides in fields such as transportation, agriculture, and education. Autonomous vehicles, AI-driven crop monitoring, and personalized learning experiences are just a few examples of how AI is making our world more efficient and innovative. As AI continues to evolve, it raises important ethical questions about data privacy, job displacement, and the role of humans in a machine-driven world. Experts believe that the next decade will be crucial in determining how AI is integrated into society, and whether its benefits can be maximized while mitigating its risks.',
    url: 'https://techcrunch.com/ai-revolution-shaping-future',
    dateTime: DateTime.parse('2024-10-11T14:45:00Z'), // Example date and time
    topic: 'Technology',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'Champions League: Quarterfinals Set After Dramatic Group Stage',
    imageurl: 'https://ichef.bbci.co.uk/ace/standard/624/cpsprodpb/EAA9/production/_106037006_mahrez.jpg',
    source: 'ESPN',
    description: 'The stage is set for the UEFA Champions League quarterfinals, following a thrilling and unpredictable group stage that saw some of Europe’s top clubs battle it out for a coveted spot in the knockout rounds. This year’s tournament has been nothing short of exciting, with surprise performances from underdog teams and nail-biting finishes that kept fans on the edge of their seats. Clubs like Real Madrid, Bayern Munich, and Manchester City have made their way to the quarterfinals, but the path has not been easy. Some matches were decided in the final minutes, while others saw dramatic comebacks that have already cemented their place in Champions League history. As the competition intensifies, fans are eagerly anticipating the upcoming matchups between the continent’s football powerhouses. Analysts are already making predictions about which clubs are most likely to advance to the semifinals, but with so many talented teams in the mix, the results are far from certain. The excitement is palpable, as the Champions League continues to deliver the drama and high-level football that fans have come to expect.',
    url: 'https://www.espn.com/champions-league-quarterfinals-set',
    dateTime: DateTime.parse('2024-10-10T16:00:00Z'), // Example date and time
    topic: 'Sports',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'COVID-19: Vaccination Rates Surge Amid New Variant Concerns',
    imageurl: 'https://media.cnn.com/api/v1/images/stellar/prod/210111232330-moderna-vaccine-210107-california.jpg?q=x_0,y_89,h_900,w_1600,c_crop/w_1280',
    source: 'Reuters',
    description: 'As concerns grow over a newly discovered COVID-19 variant, governments around the world are ramping up efforts to increase vaccination rates. The new variant, which has been shown to be more transmissible than previous strains, has sparked fears of a potential new wave of infections. In response, many countries have launched large-scale vaccination campaigns, urging citizens to get vaccinated or receive booster shots to protect themselves. Public health officials are emphasizing the importance of widespread vaccination in preventing severe illness, hospitalizations, and deaths. While vaccines remain highly effective at preventing serious cases, experts are urging caution, noting that the new variant has raised questions about vaccine efficacy against future mutations. The surge in vaccinations comes at a critical time, as many nations are attempting to return to normalcy following previous waves of the virus. Schools, businesses, and travel are gradually resuming, but the threat of the new variant looms large, forcing policymakers to consider reinstating some restrictions. Health organizations worldwide are closely monitoring the situation, hoping that increased vaccination efforts will mitigate the impact of this new variant.',
    url: 'https://www.reuters.com/covid-vaccination-surge-new-variant',
    dateTime: DateTime.parse('2024-10-09T18:20:00Z'), // Example date and time
    topic: 'Health',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'Electric Vehicles: Revolutionizing the Automotive Industry',
    imageurl: 'https://media.cnn.com/api/v1/images/stellar/prod/gettyimages-1258644779.jpg?c=16x9&q=h_653,w_1160,c_fill/f_webp',
    source: 'Bloomberg',
    description: 'The electric vehicle (EV) revolution is well underway, and it is transforming the automotive industry at a rapid pace. What was once considered a niche market for environmentally conscious consumers has now become the focal point of major automakers worldwide. Companies like Tesla, Ford, and General Motors are investing billions of dollars into EV research and production, seeking to phase out traditional internal combustion engines in favor of more sustainable electric alternatives. This shift is being driven by growing consumer demand for eco-friendly vehicles, stricter environmental regulations, and technological advancements that have made EVs more affordable and practical. The industry’s transformation is not only limited to passenger cars; electric trucks, buses, and even airplanes are being developed to reduce carbon emissions and combat climate change. Governments are also playing a crucial role in this revolution, offering tax incentives and subsidies to encourage EV adoption. However, challenges remain, such as the need for more extensive charging infrastructure and improved battery technology. Despite these hurdles, the future of transportation is undoubtedly electric, and the automotive industry is racing to adapt to this new reality.',
    url: 'https://www.bloomberg.com/ev-revolution-automotive-industry',
    dateTime: DateTime.parse('2024-10-08T11:50:00Z'), // Example date and time
    topic: 'Technology',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'Artificial Meat: The Future of Sustainable Protein?',
    imageurl: 'https://media.cnn.com/api/v1/images/stellar/prod/beef1.jpeg?c=16x9&q=h_653,w_1160,c_fill/f_webp',
    source: 'The Verge',
    description: 'As the world grapples with the environmental impact of traditional meat production, scientists and companies are turning to artificial meat as a sustainable alternative. Lab-grown meat, also known as cultured or synthetic meat, is produced by cultivating animal cells in a controlled environment, eliminating the need for animal slaughter and reducing the carbon footprint associated with farming. This innovative technology has the potential to revolutionize the global food industry by providing a viable solution to feeding a growing population while addressing concerns about animal welfare, land use, and greenhouse gas emissions. Companies like Impossible Foods and Beyond Meat are leading the charge, with products that closely mimic the taste and texture of real meat. Although the industry is still in its early stages, investment in artificial meat is skyrocketing, and experts predict that it could become a mainstream protein source within the next decade. Despite its promise, lab-grown meat faces several challenges, including high production costs, regulatory hurdles, and consumer acceptance. However, as technology advances and the cost of production decreases, artificial meat could play a pivotal role in creating a more sustainable and ethical food system.',
    url: 'https://www.theverge.com/artificial-meat-future-sustainable-protein',
    dateTime: DateTime.parse('2024-10-07T13:30:00Z'), // Example date and time
    topic: 'Health',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
  NewsModel(
    title: 'SpaceX Successfully Launches Starship to Orbit: What’s Next?',
    imageurl: 'https://ichef.bbci.co.uk/ace/standard/1024/cpsprodpb/b531/live/b7889e10-8969-11ef-8936-1185f9e7d044.jpg',
    source: 'Space.com',
    description: 'SpaceX has achieved another major milestone in its quest to revolutionize space exploration, successfully launching its Starship spacecraft into orbit for the first time. This historic mission marks a significant step forward in SpaceX’s ambitious plans to enable human colonization of the Moon and Mars. The Starship, which is designed to carry both crew and cargo, is the most powerful spacecraft ever built and is central to NASA\'s Artemis program, which aims to return humans to the Moon by 2025. The successful launch paves the way for future manned missions to Mars, where SpaceX hopes to establish a permanent human settlement. Elon Musk, the company’s CEO, has long touted the importance of making humanity a multi-planetary species, and Starship is key to that vision. The spacecraft’s reusability is also expected to significantly reduce the cost of space travel, making it more accessible for scientific missions, space tourism, and even deep space exploration. As SpaceX looks ahead, the next steps include testing the spacecraft’s landing capabilities and preparing for its first crewed missions. Excitement is building within the space community, as Starship brings us closer to a future where interplanetary travel is a reality.',
    url: 'https://www.space.com/spacex-starship-successful-orbit-launch',
    dateTime: DateTime.parse('2024-10-06T15:00:00Z'), // Example date and time
    topic: 'Science',
      language: 'en',
      likecount: 10,
      priority: 10, id: ''
  ),
];