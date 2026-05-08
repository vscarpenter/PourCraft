// prototype.jsx — Interactive prototype wiring all 5 screens together
// One shared `useBrew()` instance flows through every screen, so the dose
// the user sets on Calculator shows up on Guide, etc.

function PourCraftPrototype({ dark = false }) {
  const brew = useBrew();
  const [tab, setTab] = React.useState('brew');
  const [openTip, setOpenTip] = React.useState(null);
  const [transitioning, setTransitioning] = React.useState(false);

  // Crossfade nav transitions
  const goTab = (id) => {
    if (id === tab) return;
    setTransitioning(true);
    setTimeout(() => {
      setTab(id);
      setOpenTip(null);
      setTimeout(() => setTransitioning(false), 30);
    }, 180);
  };

  const onOpenTip = (id) => {
    setTransitioning(true);
    setTimeout(() => {
      setOpenTip(id);
      setTimeout(() => setTransitioning(false), 30);
    }, 180);
  };

  const closeTip = () => {
    setTransitioning(true);
    setTimeout(() => {
      setOpenTip(null);
      setTimeout(() => setTransitioning(false), 30);
    }, 180);
  };

  let content;
  if (openTip) {
    content = <TipDetailScreen dark={dark} tipId={openTip}
      onBack={closeTip} onTabChange={goTab}/>;
  } else if (tab === 'brew') {
    content = <CalculatorScreen dark={dark} brew={brew}
      onStartBrew={() => goTab('guide')} onTabChange={goTab}/>;
  } else if (tab === 'guide') {
    content = <GuideScreen dark={dark} brew={brew}
      onBack={() => goTab('brew')} onTabChange={goTab}/>;
  } else if (tab === 'tips') {
    content = <TipsScreen dark={dark}
      onOpenTip={onOpenTip} onTabChange={goTab}/>;
  } else if (tab === 'about') {
    content = <AboutScreen dark={dark} onTabChange={goTab}/>;
  }

  return (
    <div style={{
      opacity: transitioning ? 0 : 1,
      transition: 'opacity 0.18s ease',
    }}>
      {content}
    </div>
  );
}

window.PourCraftPrototype = PourCraftPrototype;
